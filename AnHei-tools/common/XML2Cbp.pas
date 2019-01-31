unit XML2Cbp;

interface

uses
  SysUtils, Windows, Classes, msxml, SortList, LuaDB, ComBinProperty;

type
  { XML�ڵ��ڷ���ʱ�������������� }
  TNodeNameType = (pntSource{��ԭʼ����}, pntIndex{ʹ����������});

  { XML�ڵ����������ṹ }
  PTXBPNodeDesc =^TXBPNodeDesc;
  TXBPNodeDesc = record
    NodePath: string;
    DataType: TLuaFieldType;   
    NameType: TNodeNameType;
  end;

  { XML to CBP ������ }
  TXCBPGenerator = class
  private
    FNodePath: TSortList;      //·����Ӧ�����������б�
    FCurNamePath: string;       //��ǰ����·��
    function GetCurrentSubPathDesc(const PropName: string): PTXBPNodeDesc;
    procedure ElementToProperty(AProperty: TComBinaryProperty; Element: IXMLDOMElement);
  public
    constructor Create();
    destructor Destroy();override;
    //������Ը�ʽ��
    procedure ClearNodeDesc();
    //ע�����Ը�ʽ��PropPathΪʹ�á�.���������������·��������Books.Book.name
    function AddPropertyNode(AProperty: TComBinaryProperty; NodeName: string; Data: OleVariant): PTXBPNodeDesc;
    procedure RegisterNodeDesc(const NodePath: string; DataType: TLuaFieldType; NameType: TNodeNameType);
    //��RootElement����ΪCBP������
    function BuildCBPStream(RootElement: IXMLDOMElement; Stream: TStream): Integer;
    //��RootElement����ΪCBP�ļ�
    procedure BuildCBPFile(RootElement: IXMLDOMElement; const FileName: string);
  end;
  

implementation

function PathListPathCompare(const pPath1, pPath2: Pointer): Integer;
begin
  Result := CompareStr(PTXBPNodeDesc(pPath1)^.NodePath, PTXBPNodeDesc(pPath2)^.NodePath);
end;

function SearchPathNameCompare(const pPath, Key: Pointer): Integer;
begin
  Result := CompareStr(PTXBPNodeDesc(pPath)^.NodePath, PString(Key)^);
end;

{ TXCBPGenerator }

function TXCBPGenerator.AddPropertyNode(AProperty: TComBinaryProperty;
  NodeName: string; Data: OleVariant): PTXBPNodeDesc;
var
 i :integer;
 ChildProp: TComBinaryProperty;
 ValueList: Tstringlist;
begin
  Result := GetCurrentSubPathDesc(NodeName);
  if Result = nil then Exit;     
  if Result^.NameType = pntIndex then
    NodeName := IntToStr(AProperty.FieldCount);
  case Result^.DataType of
    lfBool:begin
      AProperty.Add(NodeName).AsBool := Data;
    end;
    lfNumber:begin
      AProperty.Add(NodeName).AsNumber := Data;
    end;
    lfString:begin
      AProperty.Add(NodeName).AsString := UTF8Encode(Data);
    end;
    lfArray:begin
     ChildProp := TComBinaryProperty(AProperty.Add(NodeName));
     ValueList := tstringlist.Create;
     try
       ValueList.Delimiter := ',';
       ValueList.CommaText := UTF8Encode(Data);
       for i := 0 to ValueList.count-1 do
        if trim(UTF8Encode(ValueList[i]))<>'' then
        ChildProp.Add(inttostr(i)).AsString := UTF8Encode(ValueList[i]);
     finally
       freeandnil(ValueList);
     end;
    end;
  end;
end;

procedure TXCBPGenerator.BuildCBPFile(RootElement: IXMLDOMElement;
  const FileName: string);
var
  Stm: TStream;
begin
  Stm := TFileStream.Create(FileName, fmCreate);
  try
    BuildCBPStream(RootElement, Stm);
  finally
    Stm.Free;
  end;
end;

function TXCBPGenerator.BuildCBPStream(RootElement: IXMLDOMElement;
  Stream: TStream): Integer;
var
  AProperty: TComBinaryProperty;
begin
  FCurNamePath := '';
  AProperty := TComBinaryProperty.Create();
  try
    ElementToProperty(AProperty, RootElement);
    Result := TComBinaryPropertyStream.SaveToStream(AProperty, Stream);
  finally
    AProperty.Free;
  end;
end;

procedure TXCBPGenerator.ClearNodeDesc;
var
  I: Integer;
begin
  try
    for I := 0 to FNodePath.Count - 1 do
    begin
      Dispose(PTXBPNodeDesc(FNodePath.List^[i]));
    end;
  finally
    FNodePath.Clear();
  end;
end;

constructor TXCBPGenerator.Create;
begin
  FNodePath := TSortList.Create();
  FNodePath.OnCompare := PathListPathCompare;
  FNodePath.Sorted := True;
end;

destructor TXCBPGenerator.Destroy;
begin
  ClearNodeDesc();
  FNodePath.Free; 
  inherited;
end;

procedure TXCBPGenerator.ElementToProperty(AProperty: TComBinaryProperty;
  Element: IXMLDOMElement);
var
  AttrList: IXMLDOMNamedNodeMap;
  NodeList: IXMLDOMNodeList;     
  ChildNode: IXMLDOMNode;
  I: Integer;
  pNodeDesc: PTXBPNodeDesc;
  sOldNamePath, sNodeName: string;
  ChildProp: TComBinaryProperty;
begin
  sOldNamePath := FCurNamePath;
  if FCurNamePath <> '' then
    FCurNamePath := FCurNamePath + '.' + Element.nodeName
  else FCurNamePath := Element.nodeName;
  //��������
  AttrList := Element.attributes;
  for I := 0 to AttrList.length - 1 do
  begin
    ChildNode := AttrList.item[I];
    sNodeName := ChildNode.nodeName;
    AddPropertyNode(AProperty, sNodeName, ChildNode.nodeValue);
  end;
  //�����ӽڵ�
  NodeList := Element.childNodes;   
  for I := 0 to NodeList.length - 1 do
  begin
    ChildNode := NodeList.item[I];  
    sNodeName := ChildNode.nodeName;
    pNodeDesc := AddPropertyNode(AProperty, sNodeName, ChildNode.text);
    if (pNodeDesc <> nil) and (pNodeDesc^.DataType = lfTable) then
    begin
      if pNodeDesc^.NameType = pntSource then
        ChildProp := TComBinaryProperty(AProperty.Add(sNodeName))
      else ChildProp := TComBinaryProperty(AProperty.Add(IntToStr(AProperty.FieldCount)));
      ElementToProperty(ChildProp, ChildNode as IXMLDOMElement);
    end;
  end;
  FCurNamePath := sOldNamePath;
end;

function TXCBPGenerator.GetCurrentSubPathDesc(
  const PropName: string): PTXBPNodeDesc;
var
  nIdx: Integer;
  sPath: string;
begin
  sPath := FCurNamePath + '.' + PropName;
  nIdx := FNodePath.Search(@sPath, SearchPathNameCompare);
  if nIdx < 0 then
    Result := nil
  else Result := FNodePath.List^[nIdx];
end;

procedure TXCBPGenerator.RegisterNodeDesc(const NodePath: string;
  DataType: TLuaFieldType; NameType: TNodeNameType);
var
  pDesc: PTXBPNodeDesc;
begin
  pDesc := GetCurrentSubPathDesc(NodePath);
  if pDesc = nil then
  begin
    New(pDesc);
    pDesc^.NodePath := NodePath;
    FNodePath.Add(pDesc);
  end;
  pDesc^.DataType := DataType; 
  pDesc^.NameType := NameType;
end;

end.
