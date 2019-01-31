﻿{ VerySimpleXML v2.0 BETA 14 - a lightweight, one-unit, cross-platform XML reader/writer
  for Delphi 2010-XE5 by Dennis Spreen
  http://blog.spreendigital.de/2011/11/10/verysimplexml-a-lightweight-delphi-xml-reader-and-writer/

  (c) Copyrights 2011-2014 Dennis D. Spreen <dennis@spreendigital.de>
  This unit is free and can be used for any needs. The introduction of
  any changes and the use of those changed library is permitted without
  limitations. Only requirement:
  This text must be present without changes in all modifications of library.

  * The contents of this file are used with permission, subject to
  * the Mozilla Public License Version 1.1 (the "License"); you may   *
  * not use this file except in compliance with the License. You may  *
  * obtain a copy of the License at                                   *
  * http:  www.mozilla.org/MPL/MPL-1.1.html                           *
  *                                                                   *
  * Software distributed under the License is distributed on an       *
  * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or    *
  * implied. See the License for the specific language governing      *
  * rights and limitations under the License.                         *
}
unit Xml.VerySimple;

interface

uses
  Classes, SysUtils, Generics.Defaults, Generics.Collections;

const
  TXmlSpaces = [#$20, #$0A, #$0D, #9];

type
  TXmlVerySimple = class;
  TXmlNode = class;
  TXmlNodeType = (ntElement, ntText, ntCData, ntProcessingInstr, ntComment,
    ntDocument, ntDocType, ntXmlDecl);
  TXmlNodeTypes = set of TXmlNodeType;
  TXmlNodeList = class;
  TXmlAttributeType = (atValue, atSingle);
  TXmlOptions = set of (doNodeAutoIndent, doCompact, doParseProcessingInstr,
    doPreserveWhiteSpace, doCaseInsensitive);
  TExtractTextOptions = set of (etoDeleteStopChar, etoStopString);

  TXmlStreamReader = class(TStreamReader)
  public
    /// <summary> Current character position of the line</summary>
    CharPos: Integer;
    /// <summary> Returns True if no more characters in current line available </summary>
    EndOfLine: Boolean;
    /// <summary> Current line </summary>
    Line: String;
    /// <summary> Line break handling during reading </summary>
    LineBreak: String;
    /// <summary> Current line length </summary>
    LineLast: Integer;
    /// <summary> Extract text until chars found in StopChars </summary>
    function ExtractText(StopChars: String; Options: TExtractTextOptions)
      : String; virtual;
    /// <summary> Read next line </summary>
    function ReadLine: String; override;
    /// <summary> Returns True if the first uppercased characters at the current position match Value </summary>
    function IsUppercaseText(Value: String): Boolean; virtual;
    /// <summary> Proceed with the next character(s) (value optional, default 1) </summary>
    procedure IncCharPos(Value: Integer = 1); virtual;
  end;

  TXmlAttribute = class(TObject)
  public
    /// <summary> Attribute name </summary>
    Name: String;
    /// <summary> Attribute value (always a String) </summary>
    Value: String;
    /// <summary> Quote set while parsing an attribute, default " </summary>
    Quote: Char;
    /// <summary> Attributes without values are set to atSingle, else to atValue </summary>
    AttributeType: TXmlAttributeType;
    /// <summary> Create a new attribute </summary>
    constructor Create; virtual;
    /// <summary> Return the attribute as a String </summary>
    function AsString: String;
  end;

  TXmlAttributeList = class(TObjectList<TXmlAttribute>)
  public
    /// <summary> The xml document of the attribute list of the node</summary>
    Document: TXmlVerySimple;
    /// <summary> Add a name only attribute </summary>
    function Add(const Name: String): TXmlAttribute; overload; virtual;
    /// <summary> Returns the attribute given by name (case insensitive), NIL if no attribute found </summary>
    function Find(const Name: String): TXmlAttribute; virtual;
    /// <summary> Deletes an attribute given by name (case insensitive) </summary>
    procedure Delete(const Name: String); overload; virtual;
    /// <summary> Returns True if an attribute with the given name is found (case insensitive) </summary>
    function HasAttribute(const AttrName: String): Boolean; virtual;
    /// <summary> Returns the attributes in string representation </summary>
    function AsString: String; virtual;
  end;

  TXmlNode = class(TObject)
  private
  protected
    FDocument: TXmlVerySimple;
    procedure SetDocument(Value: TXmlVerySimple);
    function GetAttr(const AttrName: String): String; virtual;
    procedure SetAttr(const AttrName: String; const AttrValue: String); virtual;
  public
    /// <summary> All attributes of the node </summary>
    AttributeList: TXmlAttributeList;
    /// <summary> List of child nodes, never NIL </summary>
    ChildNodes: TXmlNodeList;
    /// <summary> Name of the node </summary>
    Name: String; // Node name
    /// <summary> The node type, see TXmlNodeType </summary>
    NodeType: TXmlNodeType;
    /// <summary> Parent node, may be NIL </summary>
    Parent: TXmlNode;
    /// <summary> Text value of the node </summary>
    Text: String;

    /// <summary> Creates a new XML node </summary>
    constructor Create(ANodeType: TXmlNodeType = ntElement); virtual;
    /// <summary> Removes the node from its parent and frees all of its childs </summary>
    destructor Destroy; override;
    /// <summary> Clears the attributes, the text and all of its child nodes (but not the name) </summary>
    procedure Clear;
    /// <summary> Find a child node by its name </summary>
    function Find(const Name: String; NodeTypes: TXmlNodeTypes = [ntElement])
      : TXmlNode; overload; virtual;
    /// <summary> Find a child node by name and attribute name </summary>
    function Find(const Name, AttrName: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode; overload; virtual;
    /// <summary> Find a child node by name, attribute name and attribute value </summary>
    function Find(const Name, AttrName, AttrValue: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode; overload; virtual;
    /// <summary> Return a list of child nodes with the given name and (optional) node types </summary>
    function FindNodes(const Name: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNodeList; virtual;
    /// <summary> Returns True if the attribute exists </summary>
    function HasAttribute(const AttrName: String): Boolean; virtual;
    /// <summary> Returns True if a child node with that name exits </summary>
    function HasChild(const Name: String; NodeTypes: TXmlNodeTypes = [ntElement]
      ): Boolean; virtual;
    /// <summary> Add a child node with an optional NodeType (default: ntElement)</summary>
    function AddChild(const AName: String; ANodeType: TXmlNodeType = ntElement)
      : TXmlNode; virtual;
    /// <summary> Insert a child node at a specific position with a (optional) NodeType (default: ntElement)</summary>
    function InsertChild(const Name: String; Position: Integer;
      NodeType: TXmlNodeType = ntElement): TXmlNode; virtual;
    /// <summary> Fluent interface for setting the text of the node </summary>
    function SetText(const Value: String): TXmlNode; virtual;
    /// <summary> Fluent interface for setting the node attribute given by attribute name and attribute value </summary>
    function SetAttribute(const AttrName, AttrValue: String): TXmlNode; virtual;
    /// <summary> Returns first child or NIL if there aren't any child nodes </summary>
    function FirstChild: TXmlNode; virtual;
    /// <summary> Returns last child node or NIL if there aren't any child nodes </summary>
    function LastChild: TXmlNode; virtual;
    /// <summary> Returns next sibling </summary>
    function NextSibling: TXmlNode; overload; virtual;
    /// <summary> Returns previous sibling </summary>
    function PreviousSibling: TXmlNode; overload; virtual;
    /// <summary> Returns True if the node has at least one child node </summary>
    function HasChildNodes: Boolean; virtual;
    /// <summary> Returns True if the node has a text content and no child nodes </summary>
    function IsTextElement: Boolean; virtual;
    /// <summary> Fluent interface for setting the node type </summary>
    function SetNodeType(Value: TXmlNodeType): TXmlNode; virtual;
    /// <summary> Attributes of a node, accessible by attribute name (case insensitive) </summary>
    property Attributes[const AttrName: String]: String read GetAttr
      write SetAttr;
    /// <summary> The xml document of the node </summary>
    property Document: TXmlVerySimple read FDocument write SetDocument;
    /// <summary> The node name, same as property Name </summary>
    property NodeName: String read Name write Name;
    /// <summary> The node text, same as property Text </summary>
    property NodeValue: String read Text write Text;
  end;

  TXmlNodeList = class(TObjectList<TXmlNode>)
  private
    function IsSame(const Value1, Value2: String): Boolean;
  public
    /// <summary> The xml document of the node list </summary>
    Document: TXmlVerySimple;
    /// <summary> The parent node of the node list </summary>
    Parent: TXmlNode;
    /// <summary> Adds a node and sets the parent of the node to the parent of the list </summary>
    function Add(Value: TXmlNode): Integer; overload; virtual;
    /// <summary> Creates a new node of type NodeType (default ntElement) and adds it to the list </summary>
    function Add(NodeType: TXmlNodeType = ntElement): TXmlNode;
      overload; virtual;
    /// <summary> Add a child node with an optional NodeType (default: ntElement)</summary>
    function Add(const Name: String; NodeType: TXmlNodeType = ntElement)
      : TXmlNode; overload; virtual;
    /// <summary> Find a node by its name (case sensitive), returns NIL if no node is found </summary>
    function Find(const Name: String; NodeTypes: TXmlNodeTypes = [ntElement])
      : TXmlNode; overload; virtual;
    /// <summary> Same as Find(), returnsa a node by its name (case sensitive) </summary>
    function FindNode(const Name: String; NodeTypes: TXmlNodeTypes = [ntElement]
      ): TXmlNode; virtual;
    /// <summary> Find a node that has the the given attribute, returns NIL if no node is found </summary>
    function Find(const Name, AttrName: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode; overload; virtual;
    /// <summary> Find a node that as the given attribute name and value, returns NIL otherwise </summary>
    function Find(const Name, AttrName, AttrValue: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode; overload; virtual;
    /// <summary> Return a list of child nodes with the given name and (optional) node types </summary>
    function FindNodes(const Name: String;
      NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNodeList; virtual;
    /// <summary> Returns True if the list contains a node with the given name </summary>
    function HasNode(Name: String; NodeTypes: TXmlNodeTypes = [ntElement])
      : Boolean; virtual;
    /// <summary> Inserts a node at the given position </summary>
    function Insert(const Name: String; Position: Integer;
      NodeType: TXmlNodeType = ntElement): TXmlNode; overload; virtual;
    /// <summary> Returns the first child node, same as .First </summary>
    function FirstChild: TXmlNode; virtual;
    /// <summary> Returns next sibling node </summary>
    function NextSibling(Node: TXmlNode): TXmlNode; virtual;
    /// <summary> Returns previous sibling node </summary>
    function PreviousSibling(Node: TXmlNode): TXmlNode; virtual;
    /// <summary> Returns the node at the given position </summary>
    function Get(Index: Integer): TXmlNode; virtual;
  end;

  TXmlVerySimple = class(TObject)
  private
  protected
    Root: TXmlNode;
    FHeader: TXmlNode;
    FDocumentElement: TXmlNode;
    procedure Parse(Reader: TXmlStreamReader); virtual;
    procedure ParseComment(Reader: TXmlStreamReader;
      var Parent: TXmlNode); virtual;
    procedure ParseDocType(Reader: TXmlStreamReader;
      var Parent: TXmlNode); virtual;
    procedure ParseProcessingInstr(Reader: TXmlStreamReader;
      var Parent: TXmlNode); virtual;
    procedure ParseCData(Reader: TXmlStreamReader;
      var Parent: TXmlNode); virtual;
    procedure ParseText(const Line: String; Parent: TXmlNode); virtual;
    function ParseTag(Reader: TXmlStreamReader; ParseText: Boolean;
      var Parent: TXmlNode): TXmlNode; overload; virtual;
    function ParseTag(Tag: String; var Parent: TXmlNode): TXmlNode;
      overload; virtual;
    procedure Walk(Writer: TStreamWriter; const PrefixNode: String;
      Node: TXmlNode); virtual;
    procedure SetText(const Value: String); virtual;
    function GetText: String; virtual;
    procedure SetEncoding(const Value: String); virtual;
    function GetEncoding: String; virtual;
    procedure SetVersion(const Value: String); virtual;
    function GetVersion: String; virtual;
    procedure Compose(Writer: TStreamWriter); virtual;
    procedure SetStandAlone(const Value: String); virtual;
    function GetStandAlone: String; virtual;
    function GetChildNodes: TXmlNodeList; virtual;
    procedure CreateHeaderNode; virtual;
    function ExtractText(var Line: String; StopChars: String;
      Options: TExtractTextOptions): String; virtual;
    procedure SetDocumentElement(Value: TXmlNode); virtual;
    procedure SetPreserveWhitespace(Value: Boolean);
    function GetPreserveWhitespace: Boolean;
    function IsSame(const Value1, Value2: String): Boolean;
  public
    /// <summary> Indent used for the xml output </summary>
    NodeIndentStr: String;
    /// <summary> LineBreak used for the xml output, default set to sLineBreak which is OS dependent </summary>
    LineBreak: String;
    /// <summary> Options for xml output like indentation type </summary>
    Options: TXmlOptions;

    /// <summary> Creates a new XML document parser </summary>
    constructor Create; virtual;
    /// <summary> Destroys the XML document parser </summary>
    destructor Destroy; override;
    /// <summary> Deletes all nodes </summary>
    procedure Clear; virtual;
    /// <summary> Adds a new node to the document, if it's the first ntElement then sets it as .DocumentElement </summary>
    function AddChild(const Name: String; NodeType: TXmlNodeType = ntElement)
      : TXmlNode; virtual;
    /// <summary> Creates a new node but doesn't adds it to the document nodes </summary>
    function CreateNode(const Name: String; NodeType: TXmlNodeType = ntElement)
      : TXmlNode; virtual;
    /// <summary> Loads the XML from a file </summary>
    procedure LoadFromFile(const FileName: String); virtual;
    /// <summary> Loads the XML from a stream </summary>
    procedure LoadFromStream(const Stream: TStream); virtual;
    /// <summary> Parse attributes into the attribute list for a given string </summary>
    procedure ParseAttributes(Value: String;
      AttributeList: TXmlAttributeList); virtual;
    /// <summary> Saves the XML to a file </summary>
    procedure SaveToFile(const FileName: String); virtual;
    /// <summary> Saves the XML to a stream, the encoding is specified in the .Encoding property </summary>
    procedure SaveToStream(const Stream: TStream); virtual;
    /// <summary> A list of all root nodes of the document </summary>
    property ChildNodes: TXmlNodeList read GetChildNodes;
    /// <summary> Returns the first element node </summary>
    property DocumentElement: TXmlNode read FDocumentElement
      write SetDocumentElement;
    /// <summary> Specifies the encoding of the XML file, anything else then 'utf-8' is considered as ANSI </summary>
    property Encoding: String read GetEncoding write SetEncoding;
    /// <summary> XML declarations are stored in here as Attributes </summary>
    property Header: TXmlNode read FHeader;
    /// <summary> Set to True if all spaces and linebreaks should be included as a text node, same as doPreserve option </summary>
    property PreserveWhitespace: Boolean read GetPreserveWhitespace
      write SetPreserveWhitespace;
    /// <summary> Defines the xml declaration property "StandAlone", set it to "yes" or "no" </summary>
    property StandAlone: String read GetStandAlone write SetStandAlone;
    /// <summary> The XML as a string representation </summary>
    property Text: String read GetText write SetText;
    /// <summary> Defines the xml declaration property "Version", default set to "1.0" </summary>
    property Version: String read GetVersion write SetVersion;
    /// <summary> The XML as a string representation, same as .Text </summary>
    property Xml: String read GetText write SetText;
  end;

implementation

uses
  StrUtils;

const
{$IF CompilerVersion >= 24} // Delphi XE3+ can use Low(), High() and TEncoding.ANSI
  LowStr = Low(String);
  // Get string index base, may be 0 (NextGen compiler) or 1 (standard compiler)

{$ELSE} // For any previous Delphi version overwrite High() function and use 1 as string index base
  LowStr = 1; // Use 1 as string index base

function High(const Value: String): Integer; inline;
begin
  Result := Length(Value);
end;

// Delphi XE3 added PosEx as an overloaded Pos function, so we need to wrap it in every other Delphi version
function Pos(const SubStr, S: string; Offset: Integer): Integer;
  overload; Inline;
begin
  Result := PosEx(SubStr, S, Offset);
end;
{$IFEND}
{$IF CompilerVersion < 23}

// Delphi XE2 added ANSI as Encoding, in every other Delphi version use TEncoding.Default
type
  TEncodingHelper = class helper for TEncoding
    class function GetANSI: TEncoding; static;
    class property ANSI: TEncoding read GetANSI;
  end;

class function TEncodingHelper.GetANSI: TEncoding;
begin
  Result := TEncoding.Default;
end;
{$IFEND}
{ TVerySimpleXml }

function TXmlVerySimple.AddChild(const Name: String;
  NodeType: TXmlNodeType = ntElement): TXmlNode;
begin
  Result := CreateNode(Name, NodeType);
  if (NodeType = ntElement) and (not assigned(FDocumentElement)) then
    FDocumentElement := Result;
  try
    Root.ChildNodes.Add(Result);
  except
    Result.Free;
    raise;
  end;
  Result.Document := Self;
end;

procedure TXmlVerySimple.Clear;
begin
  Root.Clear;
  FDocumentElement := NIL;
  FHeader := NIL;
end;

constructor TXmlVerySimple.Create;
begin
  inherited;
  Root := TXmlNode.Create;
  Root.NodeType := ntDocument;
  Root.Parent := Root;
  Root.Document := Self;
  NodeIndentStr := '  ';
  Options := [doNodeAutoIndent];
  LineBreak := sLineBreak;
  CreateHeaderNode;
end;

procedure TXmlVerySimple.CreateHeaderNode;
begin
  if assigned(FHeader) then
    Exit;
  FHeader := Root.ChildNodes.Insert('xml', 0, ntXmlDecl);
  FHeader.Attributes['version'] := '1.0'; // Default XML version
  FHeader.Attributes['encoding'] := 'utf-8';
end;

function TXmlVerySimple.CreateNode(const Name: String; NodeType: TXmlNodeType)
  : TXmlNode;
begin
  Result := TXmlNode.Create(NodeType);
  Result.Name := Name;
  Result.Document := Self;
end;

destructor TXmlVerySimple.Destroy;
begin
  Root.Free;
  inherited;
end;

function TXmlVerySimple.GetChildNodes: TXmlNodeList;
begin
  Result := Root.ChildNodes;
end;

function TXmlVerySimple.GetEncoding: String;
begin
  if assigned(FHeader) then
    Result := FHeader.Attributes['encoding']
  else
    Result := '';
end;

function TXmlVerySimple.GetPreserveWhitespace: Boolean;
begin
  Result := doPreserveWhiteSpace in Options;
end;

function TXmlVerySimple.GetStandAlone: String;
begin
  if assigned(FHeader) then
    Result := FHeader.Attributes['standalone']
  else
    Result := '';
end;

function TXmlVerySimple.GetVersion: String;
begin
  if assigned(FHeader) then
    Result := FHeader.Attributes['version']
  else
    Result := '';
end;

function TXmlVerySimple.IsSame(const Value1, Value2: String): Boolean;
begin
  if doCaseInsensitive in Options then
    Result := AnsiSameText(Value1, Value2)
  else
    Result := (Value1 = Value2);
end;

function TXmlVerySimple.GetText: String;
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create;
  try
    SaveToStream(Stream);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

procedure TXmlVerySimple.Compose(Writer: TStreamWriter);
var
  Child: TXmlNode;
begin
  if doCompact in Options then
  begin
    Writer.NewLine := '';
    LineBreak := '';
  end
  else
    Writer.NewLine := LineBreak;

  for Child in Root.ChildNodes do
    Walk(Writer, '', Child);
end;

procedure TXmlVerySimple.LoadFromFile(const FileName: String);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead + fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXmlVerySimple.LoadFromStream(const Stream: TStream);
var
  Reader: TXmlStreamReader;
begin
  if Encoding = '' then // none specified then use UTF8 with DetectBom
    Reader := TXmlStreamReader.Create(Stream, True)
  else if AnsiSameText(Encoding, 'utf-8') then
    Reader := TXmlStreamReader.Create(Stream, TEncoding.UTF8)
  else
    Reader := TXmlStreamReader.Create(Stream, TEncoding.ANSI);
  try
    Reader.LineBreak := LineBreak;
    Parse(Reader);
  finally
    Reader.Free;
  end;
end;

procedure TXmlVerySimple.Parse(Reader: TXmlStreamReader);
var
  Parent, Node: TXmlNode;
  FistChar: Char;
  ALine: String;
begin
  Clear;
  Parent := Root;

  while not Reader.EndOfStream do
  begin
    Reader.ReadLine;
    if (Reader.EndOfLine) and (PreserveWhitespace) then
      Parent.ChildNodes.Add(ntText).Text := LineBreak
    else
      while not Reader.EndOfLine do
      begin
        ALine := Reader.ExtractText('<', [etoDeleteStopChar]);
        if ALine <> '' then // Check for text nodes
        begin
          ParseText(ALine, Parent);
          if Reader.EndOfLine then // if no chars available then read next line
            Continue;
        end;

        FistChar := Reader.Line[Reader.CharPos];
        if FistChar = '!' then
          if Reader.IsUppercaseText('!--') then // check for a comment node
            ParseComment(Reader, Parent)
          else if Reader.IsUppercaseText('!DOCTYPE') then
            // check for a doctype node
            ParseDocType(Reader, Parent)
          else if Reader.IsUppercaseText('![CDATA[') then
            // check for a cdata node
            ParseCData(Reader, Parent)
          else
            ParseTag(Reader, False, Parent) // try to parse as tag
        else // Check for XML header / processing instructions
          if FistChar = '?' then // could be header or processing instruction
            ParseProcessingInstr(Reader, Parent)
          else
          begin // Parse a tag, the first tag in a document is the DocumentElement
            Node := ParseTag(Reader, True, Parent);
            if (not assigned(FDocumentElement)) and (Parent = Root) then
              FDocumentElement := Node;
          end;
      end;
  end;
end;

procedure TXmlVerySimple.ParseAttributes(Value: String;
  AttributeList: TXmlAttributeList);
var
  Attribute: TXmlAttribute;
  AttrName, AttrText: String;
begin
  Value := TrimLeft(Value);
  while Value <> '' do
  begin
    AttrName := ExtractText(Value, ' =', []);
    Value := TrimLeft(Value);

    Attribute := AttributeList.Add(AttrName);
    if (Value = '') or (Value[LowStr] <> '=') then
      Continue;

    Delete(Value, 1, 1);
    Attribute.AttributeType := atValue;
    ExtractText(Value, '''' + '"', []);
    Value := TrimLeft(Value);
    if Value <> '' then
    begin
      Attribute.Quote := Value[LowStr];
      Delete(Value, 1, 1);
      AttrText := ExtractText(Value, Attribute.Quote, [etoDeleteStopChar]);
      // Get Attribute Value
      AttrText := ReplaceStr(AttrText, '&amp;', '&');
      AttrText := ReplaceStr(AttrText, '&lt;', '<');
      if Attribute.Quote = '"' then
        Attribute.Value := ReplaceStr(AttrText, '&quot;', '"')
      else
        Attribute.Value := ReplaceStr(AttrText, '&apos;', '''');
      Value := TrimLeft(Value);
    end;
  end;
end;

procedure TXmlVerySimple.ParseText(const Line: String; Parent: TXmlNode);
var
  SingleChar: Char;
  Node: TXmlNode;
  TextNode: Boolean;
begin
  if PreserveWhitespace then
    TextNode := True
  else
  begin
    TextNode := False;
    for SingleChar in Line do
      if not CharInSet(SingleChar, TXmlSpaces) then
      begin
        TextNode := True;
        Break;
      end;
  end;

  if TextNode then
  begin
    Node := Parent.ChildNodes.Add(ntText);
    Node.Text := Line;
  end;
end;

procedure TXmlVerySimple.ParseCData(Reader: TXmlStreamReader;
  var Parent: TXmlNode);
var
  Node: TXmlNode;
begin
  Node := Parent.ChildNodes.Add(ntCData);
  Node.Text := Reader.ExtractText(']]>', [etoDeleteStopChar, etoStopString]);
end;

procedure TXmlVerySimple.ParseComment(Reader: TXmlStreamReader;
  var Parent: TXmlNode);
var
  Node: TXmlNode;
begin
  Node := Parent.ChildNodes.Add(ntComment);
  Node.Text := Reader.ExtractText('-->', [etoDeleteStopChar, etoStopString]);
end;

procedure TXmlVerySimple.ParseDocType(Reader: TXmlStreamReader;
  var Parent: TXmlNode);
var
  Node: TXmlNode;
  Quote: Char;
begin
  Node := Parent.ChildNodes.Add(ntDocType);
  Node.Text := Reader.ExtractText('>[', []);
  if not Reader.EndOfLine then
  begin
    Quote := Reader.Line[Reader.CharPos];
    Reader.IncCharPos;
    if Quote = '[' then
      Node.Text := Node.Text + Quote + Reader.ExtractText(']',
        [etoDeleteStopChar]) + ']' + Reader.ExtractText('>',
        [etoDeleteStopChar]);
  end;
end;

procedure TXmlVerySimple.ParseProcessingInstr(Reader: TXmlStreamReader;
  var Parent: TXmlNode);
var
  Node: TXmlNode;
  Tag: String;
begin
  Reader.IncCharPos; // omit the '?'
  Tag := Reader.ExtractText('?>', [etoDeleteStopChar, etoStopString]);
  Node := ParseTag(Tag, Parent);
  if lowercase(Node.Name) = 'xml' then
  begin
    FHeader := Node;
    FHeader.NodeType := ntXmlDecl;
  end
  else
  begin
    Node.NodeType := ntProcessingInstr;
    if not(doParseProcessingInstr in Options) then
    begin
      Node.Text := Tag;
      Node.AttributeList.Clear;
    end;
  end;
  Parent := Node.Parent;
end;

function TXmlVerySimple.ParseTag(Reader: TXmlStreamReader; ParseText: Boolean;
  var Parent: TXmlNode): TXmlNode;
var
  Tag: String;
  ALine: String;
  SingleChar: Char;
begin
  Tag := Reader.ExtractText('>', [etoDeleteStopChar]);
  Result := ParseTag(Tag, Parent);
  if Result = Parent then // only non-self closing nodes may have a text
  begin
    ALine := Reader.ExtractText('<', []);
    ALine := ReplaceStr(ALine, '&amp;', '&');
    ALine := ReplaceStr(ALine, '&lt;', '<');

    if PreserveWhitespace then
      Result.Text := ALine
    else
      for SingleChar in ALine do
        if not CharInSet(SingleChar, TXmlSpaces) then
        begin
          Result.Text := ALine;
          Break;
        end;
  end;
end;

function TXmlVerySimple.ParseTag(Tag: String; var Parent: TXmlNode): TXmlNode;
var
  Node: TXmlNode;
  ALine: String;
  CharPos: Integer;
begin
  // A closing tag does not have any attributes nor text
  if (Tag <> '') and (Tag[LowStr] = '/') then
  begin
    Result := Parent;
    Parent := Parent.Parent;
    Exit;
  end;

  // Creat a new new ntElement node
  Node := Parent.ChildNodes.Add;
  Result := Node;

  // Check for a self-closing Tag (does not have any text)
  if (Tag <> '') and (Tag[High(Tag)] = '/') then
    Delete(Tag, Length(Tag), 1)
  else
    Parent := Node;

  CharPos := Pos(' ', Tag);
  if CharPos <> 0 then // Tag may have attributes
  begin
    ALine := Tag;
    Delete(Tag, CharPos, Length(Tag));
    Delete(ALine, 1, CharPos);
    if ALine <> '' then
      ParseAttributes(ALine, Node.AttributeList);
  end;

  Node.Name := Tag;
end;

procedure TXmlVerySimple.SaveToFile(const FileName: String);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXmlVerySimple.SaveToStream(const Stream: TStream);
var
  Writer: TStreamWriter;
begin
  if AnsiSameText(Self.Encoding, 'utf-8') then
    Writer := TStreamWriter.Create(Stream, TEncoding.UTF8)
  else
    Writer := TStreamWriter.Create(Stream, TEncoding.ANSI);
  try
    Compose(Writer);
  finally
    Writer.Free;
  end;
end;

procedure TXmlVerySimple.SetDocumentElement(Value: TXmlNode);
begin
  FDocumentElement := Value;
  if Value.Parent = NIL then
    Root.ChildNodes.Add(Value);
end;

procedure TXmlVerySimple.SetEncoding(const Value: String);
begin
  CreateHeaderNode;
  FHeader.Attributes['encoding'] := Value;
end;

procedure TXmlVerySimple.SetPreserveWhitespace(Value: Boolean);
begin
  if Value then
    Options := Options + [doPreserveWhiteSpace]
  else
    Options := Options - [doPreserveWhiteSpace]
end;

procedure TXmlVerySimple.SetStandAlone(const Value: String);
begin
  CreateHeaderNode;
  FHeader.Attributes['standalone'] := Value;
end;

procedure TXmlVerySimple.SetVersion(const Value: String);
begin
  CreateHeaderNode;
  FHeader.Attributes['version'] := Value;
end;

procedure TXmlVerySimple.SetText(const Value: String);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create;
  try
    Stream.WriteString(Value);
    Stream.Position := 0;
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXmlVerySimple.Walk(Writer: TStreamWriter; const PrefixNode: String;
  Node: TXmlNode);
var
  Child: TXmlNode;
  S, Text: String;
  Indent, NextIndent: String;
begin
  if Node = Root.ChildNodes.First then
    S := '<'
  else
    S := LineBreak + PrefixNode + '<';

  case Node.NodeType of
    ntComment:
      begin
        Writer.Write(S + '!--' + Node.Text + '-->');
        Exit;
      end;
    ntDocType:
      begin
        Writer.Write(S + '!DOCTYPE ' + Node.Text + '>');
        Exit;
      end;
    ntCData:
      begin
        Writer.Write('<![CDATA[' + Node.Text + ']]>');
        Exit;
      end;
    ntText:
      begin
        Writer.Write(Node.Text);
        Exit;
      end;
    ntProcessingInstr:
      begin
        if Node.AttributeList.Count > 0 then
          Writer.Write(S + '?' + Node.Name + Node.AttributeList.AsString + '?>')
        else
          Writer.Write(S + '?' + Node.Text + '?>');
        Exit;
      end;
    ntXmlDecl:
      begin
        Writer.Write(S + '?' + Node.Name + Node.AttributeList.AsString + '?>');
        Exit;
      end;
  end;

  S := S + Node.Name + Node.AttributeList.AsString;

  // Self closing tags
  if (Node.Text = '') and (not Node.HasChildNodes) then
  begin
    Writer.Write(S + '/>');
    Exit;
  end;

  S := S + '>';
  if Node.Text <> '' then
  begin
    Text := ReplaceStr(Node.Text, '&', '&amp;');
    Text := ReplaceStr(Text, '<', '&lt;');
    S := S + Text;
  end
  else
    Text := '';

  { if (not Node.HasChildNodes) and (Node.Text <> '') and ((Node.Parent <> Root) or (Node = FDocumentElement)) then
    begin
    S := S + '</' + Node.Name + '>';
    Writer.Write(S);
    end
    else }
  begin
    Writer.Write(S);

    if doCompact in Options then
    begin
      Indent := '';
      NextIndent := '';
    end
    else
    begin
      NextIndent := PrefixNode + NodeIndentStr;
      Indent := NextIndent;
    end;

    for Child in Node.ChildNodes do
    begin
      Walk(Writer, Indent, Child);
      Indent := NextIndent;
    end;

    if (Node.HasChildNodes) or
      ((Node.LastChild <> NIL) and (Node.LastChild.NodeType <> ntText)) then
      Indent := LineBreak + PrefixNode
    else
      Indent := '';

    Writer.Write(Indent + '</' + Node.Name + '>');
  end;
end;

function TXmlVerySimple.ExtractText(var Line: String; StopChars: String;
  Options: TExtractTextOptions): String;
var
  CharPos, FoundPos: Integer;
  TestChar: Char;
begin
  FoundPos := 0;
  for TestChar in StopChars do
  begin
    CharPos := Pos(TestChar, Line);
    if (CharPos <> 0) and ((FoundPos = 0) or (CharPos < FoundPos)) then
      FoundPos := CharPos;
  end;

  if FoundPos <> 0 then
  begin
    Dec(FoundPos);
    Result := Copy(Line, 1, FoundPos);
    if etoDeleteStopChar in Options then
      Inc(FoundPos);
    Delete(Line, 1, FoundPos);
  end
  else
  begin
    Result := Line;
    Line := '';
  end;
end;

{ TXmlNode }

function TXmlNode.AddChild(const AName: String;
  ANodeType: TXmlNodeType = ntElement): TXmlNode;
begin
  Result := ChildNodes.Add(AName, ANodeType);
end;

procedure TXmlNode.Clear;
begin
  Text := '';
  AttributeList.Clear;
  ChildNodes.Clear;
end;

constructor TXmlNode.Create(ANodeType: TXmlNodeType = ntElement);
begin
  ChildNodes := TXmlNodeList.Create;
  ChildNodes.Parent := Self;
  AttributeList := TXmlAttributeList.Create;
  NodeType := ANodeType;
end;

destructor TXmlNode.Destroy;
begin
  if assigned(Parent) then
    Parent.ChildNodes.Extract(Self);

{$IFDEF  Windows}
  AttributeList.Free;
  ChildNodes.Free;
{$ELSE}
  AttributeList.DisposeOf;
  ChildNodes.DisposeOf;
{$ENDIF}
  inherited;
end;

function TXmlNode.Find(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
begin
  Result := ChildNodes.Find(Name, NodeTypes);
end;

function TXmlNode.Find(const Name, AttrName, AttrValue: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
begin
  Result := ChildNodes.Find(Name, AttrName, AttrValue, NodeTypes);
end;

function TXmlNode.Find(const Name, AttrName: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
begin
  Result := ChildNodes.Find(Name, AttrName, NodeTypes);
end;

function TXmlNode.FindNodes(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNodeList;
begin
  Result := ChildNodes.FindNodes(Name, NodeTypes);
end;

function TXmlNode.FirstChild: TXmlNode;
begin
  Result := ChildNodes.First;
end;

function TXmlNode.GetAttr(const AttrName: String): String;
var
  Attribute: TXmlAttribute;
begin
  Attribute := AttributeList.Find(AttrName);
  if assigned(Attribute) then
    Result := Attribute.Value
  else
    Result := '';
end;

function TXmlNode.HasAttribute(const AttrName: String): Boolean;
begin
  Result := AttributeList.HasAttribute(AttrName);
end;

function TXmlNode.HasChild(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): Boolean;
begin
  Result := ChildNodes.HasNode(Name, NodeTypes);
end;

function TXmlNode.HasChildNodes: Boolean;
begin
  Result := (ChildNodes.Count > 0);
end;

function TXmlNode.InsertChild(const Name: String; Position: Integer;
  NodeType: TXmlNodeType = ntElement): TXmlNode;
begin
  Result := ChildNodes.Insert(Name, Position);
  if assigned(Result) then
    Result.Parent := Self;
end;

function TXmlNode.IsTextElement: Boolean;
begin
  Result := (Text <> '') and (not HasChildNodes);
end;

function TXmlNode.LastChild: TXmlNode;
begin
  if ChildNodes.Count > 0 then
    Result := ChildNodes.Last
  else
    Result := NIL;
end;

function TXmlNode.NextSibling: TXmlNode;
begin
  if not assigned(Parent) then
    Result := NIL
  else
    Result := Parent.ChildNodes.NextSibling(Self);
end;

function TXmlNode.PreviousSibling: TXmlNode;
begin
  if not assigned(Parent) then
    Result := NIL
  else
    Result := Parent.ChildNodes.PreviousSibling(Self);
end;

procedure TXmlNode.SetAttr(const AttrName, AttrValue: String);
begin
  SetAttribute(AttrName, AttrValue);
end;

function TXmlNode.SetAttribute(const AttrName, AttrValue: String): TXmlNode;
var
  Attribute: TXmlAttribute;
begin
  Attribute := AttributeList.Find(AttrName); // Search for given name
  if not assigned(Attribute) then // If attribute is not found, create one
    Attribute := AttributeList.Add(AttrName);
  Attribute.AttributeType := atValue;
  Attribute.Name := AttrName;
  // this allows rewriting of the attribute name (lower/upper case)
  Attribute.Value := AttrValue;
  Result := Self;
end;

procedure TXmlNode.SetDocument(Value: TXmlVerySimple);
begin
  FDocument := Value;
  AttributeList.Document := Value;
  ChildNodes.Document := Value;
end;

function TXmlNode.SetNodeType(Value: TXmlNodeType): TXmlNode;
begin
  NodeType := Value;
  Result := Self;
end;

function TXmlNode.SetText(const Value: String): TXmlNode;
begin
  Text := Value;
  Result := Self;
end;

{ TXmlAttributeList }

function TXmlAttributeList.Add(const Name: String): TXmlAttribute;
begin
  Result := TXmlAttribute.Create;
  Result.Name := Name;
  try
    Add(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TXmlAttributeList.AsString: String;
var
  Attribute: TXmlAttribute;
begin
  Result := '';
  for Attribute in Self do
    Result := Result + ' ' + Attribute.AsString;
end;

procedure TXmlAttributeList.Delete(const Name: String);
var
  Attribute: TXmlAttribute;
begin
  Attribute := Find(Name);
  if assigned(Attribute) then
    Remove(Attribute);
end;

function TXmlAttributeList.Find(const Name: String): TXmlAttribute;
var
  Attribute: TXmlAttribute;
begin
  Result := NIL;
  for Attribute in Self do
    if ((assigned(Document) and Document.IsSame(Attribute.Name, Name)) or
      // use the documents text comparison
      ((not assigned(Document)) and (Attribute.Name = Name))) then
    // or if not assigned then compare names case sensitive
    begin
      Result := Attribute;
      Break;
    end;
end;

function TXmlAttributeList.HasAttribute(const AttrName: String): Boolean;
begin
  Result := assigned(Find(AttrName));
end;

{ TXmlNodeList }

function TXmlNodeList.Find(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
var
  Node: TXmlNode;
begin
  Result := NIL;
  for Node in Self do
    if ((NodeTypes = []) or (Node.NodeType in NodeTypes)) and
      (IsSame(Node.Name, Name)) then
    begin
      Result := Node;
      Break;
    end;
end;

function TXmlNodeList.Add(Value: TXmlNode): Integer;
begin
  Result := inherited Add(Value);
  Value.Parent := Parent;
end;

function TXmlNodeList.Add(NodeType: TXmlNodeType = ntElement): TXmlNode;
begin
  Result := TXmlNode.Create(NodeType);
  try
    Add(Result);
  except
    Result.Free;
    raise;
  end;
  Result.Document := Document;
end;

function TXmlNodeList.Add(const Name: String; NodeType: TXmlNodeType): TXmlNode;
begin
  Result := Add(NodeType);
  Result.Name := Name;
end;

function TXmlNodeList.Find(const Name, AttrName, AttrValue: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
var
  Node: TXmlNode;
begin
  Result := NIL;
  for Node in Self do
    if ((NodeTypes = []) or (Node.NodeType in NodeTypes)) and
    // if no type specified or node type in types
      IsSame(Node.Name, Name) and Node.HasAttribute(AttrName) and
      IsSame(Node.Attributes[AttrName], AttrValue) then
    begin
      Result := Node;
      Break;
    end;
end;

function TXmlNodeList.Find(const Name, AttrName: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
var
  Node: TXmlNode;
begin
  Result := NIL;
  for Node in Self do
    if ((NodeTypes = []) or (Node.NodeType in NodeTypes)) and
      IsSame(Node.Name, Name) and Node.HasAttribute(AttrName) then
    begin
      Result := Node;
      Break;
    end;
end;

function TXmlNodeList.FindNode(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNode;
begin
  Result := Find(Name, NodeTypes);
end;

function TXmlNodeList.FindNodes(const Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): TXmlNodeList;
var
  Node: TXmlNode;
begin
  Result := TXmlNodeList.Create(False);
  Result.Document := Document;
  try
    for Node in Self do
      if ((NodeTypes = []) or (Node.NodeType in NodeTypes)) and
        IsSame(Node.Name, Name) then
      begin
        Result.Parent := Node.Parent;
        Result.Add(Node);
      end;
    Result.Parent := NIL;
  except
    Result.Free;
    raise;
  end;
end;

function TXmlNodeList.FirstChild: TXmlNode;
begin
  Result := First;
end;

function TXmlNodeList.Get(Index: Integer): TXmlNode;
begin
  Result := Items[Index];
end;

function TXmlNodeList.HasNode(Name: String;
  NodeTypes: TXmlNodeTypes = [ntElement]): Boolean;
begin
  Result := assigned(Find(Name, NodeTypes));
end;

function TXmlNodeList.Insert(const Name: String; Position: Integer;
  NodeType: TXmlNodeType = ntElement): TXmlNode;
begin
  Result := TXmlNode.Create;
  Result.Document := Document;
  try
    Result.Name := Name;
    Result.NodeType := NodeType;
    Insert(Position, Result);
  except
    Result.Free;
    raise;
  end;
end;

function TXmlNodeList.IsSame(const Value1, Value2: String): Boolean;
begin
  Result := ((assigned(Document) and Document.IsSame(Value1, Value2)) or
    // use the documents text comparison
    ((not assigned(Document)) and (Value1 = Value2)));
  // or if not assigned then compare names case sensitive
end;

function TXmlNodeList.NextSibling(Node: TXmlNode): TXmlNode;
var
  Index: Integer;
begin
  if (not assigned(Node)) and (Count > 0) then
    Result := First
  else
  begin
    Index := Self.IndexOf(Node);
    if (Index >= 0) and (Index + 1 < Count) then
      Result := Self[Index]
    else
      Result := NIL;
  end;
end;

function TXmlNodeList.PreviousSibling(Node: TXmlNode): TXmlNode;
var
  Index: Integer;
begin
  Index := Self.IndexOf(Node);
  if Index - 1 >= 0 then
    Result := Self[Index]
  else
    Result := NIL;
end;

{ TXmlStreamReader }

procedure TXmlStreamReader.IncCharPos(Value: Integer);
begin
  Inc(CharPos, Value);
  EndOfLine := (CharPos > LineLast);
end;

function TXmlStreamReader.IsUppercaseText(Value: String): Boolean;
begin
  Result := (Uppercase(Copy(Line, CharPos, Length(Value))) = Value);
  if Result then
    IncCharPos(Length(Value));
end;

function TXmlStreamReader.ExtractText(StopChars: String;
  Options: TExtractTextOptions): String;
var
  TempCharPos, FoundPos: Integer;
  StopChar: Char;
  IncPos: Integer;
begin
  Result := '';
  repeat
    if not EndOfLine then
    begin
      FoundPos := 0;
      if etoStopString in Options then
        FoundPos := Pos(StopChars, Line, CharPos + (1 - LowStr))
      else
        for StopChar in StopChars do
        begin
          TempCharPos := Pos(StopChar, Line, CharPos + (1 - LowStr));
          if (TempCharPos <> 0) and ((FoundPos = 0) or (TempCharPos < FoundPos))
          then
            FoundPos := TempCharPos;
        end;

      if FoundPos <> 0 then
      begin
        IncPos := FoundPos - (CharPos + (1 - LowStr));
        if IncPos <> 0 then
          Result := Result + Copy(Line, CharPos + (1 - LowStr), IncPos);
        if etoDeleteStopChar in Options then
          if etoStopString in Options then
            Inc(IncPos, Length(StopChars))
          else
            Inc(IncPos);
        IncCharPos(IncPos);
        Exit;
      end;

      Result := Result + Copy(Line, CharPos + (1 - LowStr));
    end;

    if EndOfStream then // if no lines left then exit
    begin
      EndOfLine := True; // Set EndOfLine
      Exit;
    end;
    Line := ReadLine;
    Result := Result + LineBreak;
  until False;
end;

function TXmlStreamReader.ReadLine: String;
begin
  Result := inherited;
  Line := Result;
  CharPos := LowStr;
  LineLast := High(Line);
  IncCharPos(0);
end;

{ TXmlAttribute }

function TXmlAttribute.AsString: String;
var
  EscapedValue: String;
begin
  Result := Name;
  if AttributeType = atSingle then
    Exit;

  EscapedValue := ReplaceStr(Value, '&', '&amp;');
  EscapedValue := ReplaceStr(EscapedValue, '<', '&lt;');

  if Quote = '"' then
    EscapedValue := ReplaceStr(EscapedValue, '"', '&quot;')
  else
    EscapedValue := ReplaceStr(EscapedValue, '''', '&apos;');

  Result := Result + '=' + Quote + EscapedValue + Quote;
end;

constructor TXmlAttribute.Create;
begin
  AttributeType := atSingle;
  Quote := '"'; // Default attribute quotating mark
end;

end.
