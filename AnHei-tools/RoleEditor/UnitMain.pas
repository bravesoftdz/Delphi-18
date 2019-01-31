unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ImgList, ToolWin, Menus, ComObj, msXml, DB, ADODB, Tabs, StdCtrls,
  UnitMonItemReader, StrUtils, XmltoLua, XML2Cbp, LuaDB, UBatchUpdatePrice, Clipbrd;

const
  defBool = 'false';
  defint = 0;
  DocStateName = 'RoleEditor';
  RolePath = '%s\config\quest\Role.xml';
  sMsgSuccess = '��ϲ �����ѳɹ����';
  sEnviromentFile = '%s\envir\Sence.xml';
  sItemFile = '%s\config\item\StdItems.xml';
  sMonsterFile = '%s\config\monster\Monsters.xml';
  defGPath = '..idgp\AnHei\!SC\Server\data\';
  defCbpPath = '..\521g\idgp\AnHei\!SC\Client';
  sLuaToCbpTempFile   = 'LuaToCBP.txt';
  RepeatStartID = 8001;
  Sinherited = '%s|%d'; //����ID|����ID(��1��ʼ)
  SinheritedFile = '%s\backstage\questsort.txt';

//�������� ģʽ 8��9 10 id ������Ʒ
  CondItemindexSet = [8,9,10];
//����Ŀ�� ģʽ 0 1 2 4 23 24 31 Ŀ��id ������Ʒ
  TargetItemindexSet = [1,2,4,23,24,31,36];
//������ ģʽ 0 ������Ʒ
  AwordItemIndexSet = [0];

  //����Ŀ�� ģʽ  ���ع���
  TargetMonindexSet = [0,35];

  //����Ŀ�� ģʽ  ���ص�ͼ
  TaegetSenceIndexSet = [19];

//  ����Ŀ�� ģʽ  ����npc
  TaegetNpcIndexSet = [18,20];



//*******xml�ڵ�start*************
  RoleMainSecName   = 'Roles';
      RoleClassSecName  = 'Class';
       RoleClassNameAtbName  = 'Name';
      RoleSecName       = 'Role';
        RoleIdAtbName = 'id';   //����id
        RoleNameAtbName = 'name';   //��������
        RoleInheritedAtbName = 'parentid';   //������ID�����ֵΪ-1���ʾû�и�����(�ͻ���û���õ�)��������������길�������ܽӴ�����
        RoleKindAttrName = 'type';   //0����������1��֧������2�ǻ������񣬵ȵ�
        RoleNeedLevel = 'level';   //�ﵽһ���ȼ����ý�����
        circleAttr = 'circle';   //����ǹ̶�������,��ʾ��ǰ�������ڵڼ���
        entrustAttr = 'entrust';   //��ö౶��õ�Ԫ�����ߵ��
        multiAwardAttr = 'multiAward'; //��ü�������
        doubleYBAttr = 'doubleYB'; //bool  �Ƿ�ʹ��Ԫ��
        DoubleMoneyTypeAttr = 'DoubleMoneyType'; //��ȡ��Ǯ����  Ĭ��0
        AgainMoneyTypeAttr = 'AgainMoneyType';   //�����Ǯ����  Ĭ��0
        RoleAbortable = 'cangiveup';   //�ɷ����  boolean
        automountAttr = 'automount';   //�������Զ�������
        RoleWayfindingByDriver = 'autoRun';   //�ӵ������Ժ��Ƿ��Զ�Ѱ·��Ĭ��false�ǲ��Զ�Ѱ·�ģ�true��ʾ�Զ�Ѱ·
        RoleDescSecName = 'content';   //���������������ٿͻ��˵������������ʾ�ļ����������ʹ��HTML�﷨��Ѱ·ָ��
        guideIdAttr = 'guideId';   //�������ڵ�ID��0��ʾĬ�ϣ������ã�1��������������̳ǵı�ʯǿ�����棬2��������ɡ�������ί�н��棬3������������򿪽���������Ҫ��������
        RoleTimeValue = 'timelimit';   //����ʱ�����ƣ���λ�����ӣ��ӽ������ʼ��ʱ��������ʱ�����ǰ������񣬷��������Զ�ע����0��ʾ������ʱ��
        RoleIntervalValue = 'interval';   //�������ڣ���λ���롣0��ʾ���������Զֻ����һ�Ρ��������ڱ�ʾ�ӵ���0�㿪ʼ�����������Ķ೤ʱ�������ٴν�����
        RoleMaxTimeAtbName = 'maxcount';   //ÿ�����������ڣ����������ٴΣ�0��ʾ������
        ExcludeChilds = 'excludetree';   //������˴�����������������ٽӴ�����
        speedYbAttr = 'speedYb';   //�����Ƿ���Կ�����ɣ�������ɾͱ�ʾ��Ҫ��Ԫ��������int
        RoleAutoTransmitAttrName = 'showTimerBox';   //���������ʾ����
        RoleAutoCompleteAttrName = 'BCompleteTimerBox';   //����������ʾ����
        randomTargetAttr = 'randomTarget';   //���Ŀ��
        notGiveAwardAttr = 'notGiveAward';   //��������

        maxcirAttr = 'maxcir';   //���
        starAttr = 'star';   //�����������Ԫ������
        PromAttr = 'prom';   //����������-������NPC����
          PromtypeAttr = 'type';   //-����Ľ��ܺ��ύ���ͣ�0��ʾ��NPC�Ͻ�����1��ʾ�����������ʱ�Զ����ܣ�2��ʾ�ɽű�ϵͳ��̬����
          RolePromulgationMap = 'scene';   //���������NPC���ڳ�������,  --���������NPC���ڳ������ƣ���typeֵ��0��ʱ���������Ϊnil, --ע�⽫���ַŵ����԰���
          RolePromulgationNPC = 'npc';   // "���������NPC����", --���������NPC���ƣ���typeֵ��0��ʱ���������Ϊnil
          PromisFPAttr = 'isFP';   //�Ƿ�����ٴ���0�����ٴ���1�������ٴ�
        CompAttr = 'comp';   //����������-������NPC����
          ComptypeAttr = 'type';   //-����Ľ��ܺ��ύ���ͣ�0��ʾ��NPC�Ͻ�����1��ʾ�����������ʱ�Զ����ܣ�2��ʾ�ɽű�ϵͳ��̬����
          RoleAcceptMap = 'scene';   //���������NPC���ڳ�������,  --���������NPC���ڳ������ƣ���typeֵ��0��ʱ���������Ϊnil, --ע�⽫���ַŵ����԰���
          RoleAcceptNPC = 'npc';   // "���������NPC����", --���������NPC���ƣ���typeֵ��0��ʱ���������Ϊnil
          CompisFPAttr = 'isFP';   //�Ƿ�����ٴ���0�����ٴ���1�������ٴ�
       RoleItemsSceName= 'target';   //Ŀ���б�
         RoleItemSecName= 'targets';
          ItemExecModeAtbName = 'type';   //����id������SamleQuest.txt��
          ItemExecIdAtbName = 'id';   //Ŀ��id������typeȷ��id�����ͣ�����Ʒid������id�ȵȣ��ڴ��������Ψһ�ķ�0ֵ�����ֵΪ65000��
          ItemNeedCountAtbName = 'count';   //Ŀ����ɵ�����
          dataAttr = 'data';   //ֵΪ�Զ�����������ƣ��Զ���������Ҫͨ���ű���������ɵ�ֵ��
          dataMonsterAttr = 'dataMonster';   //dataֵΪ�Զ�����������ƣ���ʾ�����Լ�Ҫ��ɵ�����
          rewardIdAttr = 'rewardId';   //Ŀ����������Ľ���id
          useListAttr = 'useList';   //�Ƿ�ʹ���б���ʽ����
          locationesAttr = 'location';   //����Ŀ��ص㣬�������ڽ����Զ�Ѱ·
           locationAttr = 'locationes';   //����Ŀ��ص㣬�������ڽ����Զ�Ѱ·
            sceneidAttr = 'sceneid';   //����ID
            entityNameAttr = 'entityName';   //���entityName��ʾ���ǹ����NPC��������Բ�����x��y
            locationXAttr = 'x';
            locationYAttr = 'y';
            hideFastTransferAttr = 'hideFastTransfer';   //���ؿ촫��ť��trueΪ����ʾ��falseΪ��ʾ��Ĭ�ϲ���ʾ
            PassesAttr= 'pass';   //�����location��Ҫ������ǰ��ص��б�
             PassAttr= 'passes';   //�����location��Ҫ������ǰ��ص��б�
              PasssceneidAttr = 'sceneid';
              PassentityNameAttr = 'entityName';   //���entityName��ʾ���ǹ����NPC��������Բ�����x��y
              actionDescAttr = 'actionDesc';   //��Ϊ����
              xAttr = 'x';
              yAttr = 'y';
        RoleAwardsSecName = 'awards';
          AwardTagAttr = 'AwardTag';   //��Ӧ�Ľ����ڵ�
          TagAttr = 'Tag';   //�����ڵ�ֵ �ɳ����Զ�д��

         RoleAwardSecName = 'award';
          AwardModeAtbName = 'type';   //0-127, 127Ϊ�Զ��影����id����Ϊnull��count����Ϊnull,�Զ��影���ĸ�����ͨ���ű���ɵģ�
          AWardItemIdAtbName = 'id';   //����ID
          AWardCountAtbName = 'count';   //��������
          AWardQualityAtbName = 'quality';   //Ʒ��
          AWardStrongAtbName = 'strong';   //ǿ��
          groupAttr = 'group';   //group��ʾ�Ƿ��ѡ��0��ʾ����ѡ�����ͣ��������ʾ��ѡ����
          AWardItemBindAtbName = 'bind';   //��
          jobAttr = 'job';   //ְҵ
          sexAttr = 'sex';   //�Ա�
          levelRateAttr = 'levelRate';   //���������ȼ�����
          ringRateAttr = 'ringRate';   //��������������ɴ�������
          vipLevelAttr = 'vipLevel';   //vip�ȼ�
          bossLevelAttr = 'bossLevel';   //boss�ȼ���boss�ɳ��ȼ�����Ʒ�ȼ���ͬ��Ϊ����Ʒ��
          importantLevelAttr = 'importantLevel';   //��Ҫ�̶�,����ĳЩ�ط���������ʾ
          initAttrsAttr = 'initAttrs';   //��Ʒ����,�;�������һ��
          datastrAttr = 'datastr';   //��������
        RoleConditionS = 'conds';   //����������
         RoleCondition = 'cond';   //����������
          CondtypeAttr = 'type';   //��������
          CondidAttr = 'id';   //�������ID�����ݲ�ͬtype�в�ͬ����˼�������ռ���Ʒ��������Ʒid��
          CondCountAttr = 'count';   //������������������ݲ�ͬtype�в�ͬ����˼�������ռ���Ʒ��������Ʒ��������
        surpriseAwardTable = 'surpriseAward';
         surpriseAwardSTable = 'surpriseAwardS';
          surpriseawardProbAttr ='prob'; //��ϲ�������˶� ����Χ ��1-1000��
          surpriseawardRateAttr ='rate'; //��ϲ�������ʣ�֧��С���㣩
        MultiAwardTable = 'getMultiAward';
         MultiAwardSTable = 'getMultiAwardS';
          MAMoneyTypeAttr ='moneyType'; //��ϲ�������˶� ����Χ ��1-1000��
          MARateAttr ='rate'; //��ϲ�������ʣ�֧��С���㣩
          MAmoneyCountAttr ='moneyCount'; //��ϲ�������ʣ�֧��С���㣩

        RolePromTalkSecName = 'PromMsTalks';   //�ɽ������
        RoleCompTalkSecName = 'CompMsTalks';   //���������Ի�
        RoleAcceptStorySecName = 'CompMsTip';   //δ��������
        RoleFinishStorySecName = 'PassMsTip';   //���������


  RoleStatSecName    = 'Stat';
    StatNewRoleId    = 'NextId';
    StatRepeatId     = 'RepeatID';
    StatAttrOfOpenFlag= 'OpenFlag';

  RoleVersion    = 'RoleVersion';
    RoleVersionAttribute    = 'Version';

  RoleRecycleResScName = 'Recycle';
    TrushSecName = 'Trush';
    TrushRepeatName = 'RepeatTrush';
    TrushIdAttrName = 'Id';

  SYS_RESEVED_MAP      = 'ϵͳ������ͼ';
  ROLE_AUTO_PROMULGATE = 'AUTORUN';
  ROLE_ITEM_PROMULGATE = 'ITEMRUN';
  ROLE_AUTO_COMPLATE   = 'AUTOCOMPLATE';

  ROLE_NPC_AUTO_PROMULGATE_ID = -1;
  ROLE_NPC_ITEM_PROMULGATE_ID = -2;
  ROLE_NPC_AUTO_COMPLETE_ID   = -3;


  ROLEVERSION_130409  = '130409';
  ROLEVERSION_130415  = '130415';
  ROLEVERSION_13041502  = '13041502';
  ROLEVERSION_130416  = '130416';
  ROLEVERSION_130417  = '130417';
  ROLEVERSION_13041702  = '13041702';
  ROLEVERSION_130418  = '130418';
  ROLEVERSION_130508  = '130508';
  ROLEVERSION_130723  = '130723';
  ROLEVERSION_130802  = '130802';
  ROLEVERSION_130807  = '130807';
  ROLEVERSION_130809  = '130809';
  ROLEVERSION_130903  = '130903';
  ROLEVERSION_13090302  = '13090302';
  ROLEVERSION_130909  = '130909';
  ROLEVERSION_130912  = '130912';
  ROLEVERSION_130917  = '130917';
  ROLEVERSION_140412  = '140412';
  ROLEVERSION_140421  = '140421';
  ROLEVERSION_140424  = '140424';
  ROLEVERSION_140523  = '140523';
  CURRENTROLE_VERSION = ROLEVERSION_140523;

  SHOWROLESINTREE     = TRUE;

  EnvirLangCategoryId= 3;
  RoleLangCategoryId = 2;
  ItemLangCategoryId = 4;
  MonLangCategoryId = 5;
  MagicCategoryId = 27;
  sConfigName = 'TaskEditorConfig.ini';//����༭�������ļ�
    sMainConfigKey  = 'RoleEditor';   // ����༭�������ļ����ڵ�
      sCbpPath  = 'CbpPath';          //cbp�ļ������ļ�·����Ϣ
      sUserName = 'UserName';          //�û��������ĵ�ʱ��ʾ
      sIsKeepLanguage  = 'IsKeepLanguage';//�Ƿ��ס����
      sLanguageName  = 'LanguageName';//��ǰʹ������
      sDataPath = 'DataPath';
  CbpFileName = 'stdquest.cbp';

//*******xml�ڵ�start*************
            AWardItemTimeAtbName = 'Time';
            AWardHole1AtbName = 'Hole1';

        QuickCompNeedsSecName = 'QuickCompNeeds';
          QuickCompNeedSecName  = 'QuickCompNeed';
          QuickModeAtbName  = 'Mode';
          QuickItemIdAtbName = 'ItemId';
          QuickCountAtbName = 'Count';






type
  TRoleExecuteMode    = (reNone, reGetItem, reKillMon, reCustom, reTakeOn,
                         reTrainSkill, reKillForeigner, reBuyItem, reKillLevelMon, reJoinGuild,
                         reUseXpSkill,reStrengthenItem, reTameMon, reBuyCommissionItem);
  TRoleNeedCount      = type Word;
  TRoleItem  = record
    btExecuteMode   :TRoleExecuteMode;
    btQuality       :Byte;
    btStrongLevel   :Byte;
    btJob           :Byte;
    wExecuteId      :Word;  //ִ��ID ��TDBUserRoleItem�ṹ�е�Exec�ֶα�ʾ������������Ŀ��ִ��ID��ɱ�ֵĹ���ID���Զ���������Ŀ��ID)��\
                            //��ֵ���$8000λ��������wDone�ֶ���ϳ�32λ�������ڱ�ʶ������ĵ���ʱ�䡣\
                            //��������ϵͳ��ʵ��ִ��ID����С�ڵ���$7FFF��
    wNeedCount      :TRoleNeedCount;
    sLocation       :string;
    pCustomData     :Pointer;

    
  end;

  TRoleNeedsMode = ( rnNone, rnItem, rnGold, rnGameGold );
  TRoleNeed = record
   Mode      : TRoleNeedsMode;
   ItemId    : Integer;
   Count     : Integer;
  end;

  TRoleAwardMode      = (raNone, raItem);

  TRoleAwardCount     = type Cardinal;

  PTAwardSelectItem=^TAwardSelectItem;
  TAwardSelectItem = record
    wItemId:  Word;
    wCount :  Word;    
    btQuality     : Byte;
    btStrongLevel : Byte;
    wRcv1  :  Word;
  end;

  PTAwardSelectItems= ^TAwardSelectItems;
  TAwardSelectItems = array of TAwardSelectItem;

  TRoleCond = record
    bttype : Byte;
    id    :integer;
    count :integer;
  end;

  TRoleAward = record
    btType        : Byte;
    Id          :Integer;
    dwWardCount       :integer;
    btQuality     : Byte;
    btStrongLevel : Byte;
    btGruop       :Byte; //group��ʾ�Ƿ��ѡ��0��ʾ����ѡ�����ͣ��������ʾ��ѡ����
    bind         : string; // false / true
    job          : integer;// jobΪ-1��ʾ������ְҵ��
    sex          : Integer;// sex=-1Ҳ�ǲ������Ա�
    levelRate     : string;
    ringRate      : string;
    vipLevel      : integer;
    bossLevel     : integer;
    importantLevel: integer;
    initAttrs     : integer;
    datastr       : string;
    end;
type



  

  TRoleTimeNeed = (rtNone, rtTime, rtDayMax, rtWeekMax);

  TRoleDateTime = record
    case Integer of
      0: (lValue: Int64;);
      1: (
          wYear   : Word;
          btMonth : Byte;
          btDay   : Byte;
          btHour  : Byte;
          btMin   : Byte;
          btSec   : Byte;
          btMSec  : Byte;    //0-99
         );
  end;

  TRoleIntervalType = (riNone, riTime, riDayMax);
  
  PTRole= ^TRole;
  TRole = record
    wRoleId         :Word;
    wInherited      :Word;
    btMaxTime       :Byte;
    btTimeNeed      :TRoleTimeNeed;
    RoleTime        :TRoleDateTime;
    sClassRoot      :string;
    sRoleName       :string;
    sRoleDesc       :string;
    RoleNeeds       :array of TRoleItem;
    RoleAwards      :array of TRoleAward;
  end;

  TRoleJob = (rjNone, rjYongJiang, rjShenMou, rjJianXiu, rjFeiYu);

const

  RoleExecuteModeStr : array [0..42] of string
                        = (
                        '0-ɱ���ࡢ', '1-�ռ��ࡢ', '2-�����ࡢ', '3-����λ��', '4-������',
                        '5-��ɫ�ĵȼ����', '6-��ɫ���ڰ��ɵȼ�', '7-����ǿ�����', '8-ɱ�ж���Ӫ���', '9-ɱָ���ȼ��Ĺ�',
                        '10-���ָ����������', '11-��ɫɱ¾ֵ', '12-ָ�����������', '13-��ɫ���ɹ��׷�', '14-��ɫ��Ӫ����',
                        '15-�ͻ��˴�����:idΪ1�����ص�½��', '16-ָ��������ID', '17-��ָ����������������', '18-ָ��NPC', '19-����ĳ���ID��',
                        '20-���ҵ�NPC', '21-����ָ��NPC��Ŀ�곡����Ŀ��NPC����', '22-��̸����NPC�͸�������ң�ֱ���Ѹ�NPC����Ŀ�곡��', '23-ʹ�ù��߲ɼ�һ��ָ����Ʒ', '24-ʹ�ù�������һ��ָ����Ʒ',
                        '25-����������', '26-�Ƿ���ʦ��', '27-�Ƿ���ͽ��', '28-�Ƿ��н��', '29-�Ƿ��а���',
                        '30-�Ƿ��к��ѣ�����������', '31-ʹ��ĳ����Ʒ', '32-ѧϰһ�����ܣ������Ǽ���ID�����ܵȼ�', '33-���������װ�Ƿ��ռ���ȫ', '34-����ί����չ����',
                        '35-���ֹ�������һ��', '36-������Ʒ������ռ�һ��', '37-װ��/����ǿ�����', '38-���������', '39-��������',
                        '40-Ŀ�����', '127-�Զ�������', '256-������'
                        );

  RoleTypeStr : array [0..24] of string
                       =(
                        '0-��������','1-֧������','2-��������','3-�ճ�����','4-��������',
                        '5-ѭ������','6-��������','7-��������','8-��Ӫ����','9-װ��',
                        '10-����','11-���','12-��������/��ħˢ������','13-�Ƹ���������','14-������',
                        '15-��������','16-��װ����','17-��ǿ����','18-ѫ������','19-��������',
                        '20-�Դ�����','21-��������','22-�һ�����','23-��������','24-��������'
                        );


  RoleAwardModeStr   : array [0..39] of string
                        = (
                          '0-װ��������', '1-��Ϊ', '2-��ɫ����ֵ', '3-���ɹ���ֵ', '4-��Ӫ����',
                          '5-������', '6-����', '7-���', '8-��ν', '9-��������',
                          '10-����ս��', '11-�ɾ͵�', '12-����', '13-��������', '14-������Ծ��',
                          '15-Ԫ��', '16-���ٶ�', '17-�hʯ', '18-���̼���XPֵ', '19-��������',
                          '20-�����Ӿ���', '21-����', '22-ת������', '23-ŭ��', '24-boss',
                          '25-�������', '26-��������', '27-�л��ʽ�', '28-���ܶ�',
                          '29-����','30-����Ӣ�۵ľ���','31-���ӳ�սӢ�۵ȼ�','32-���������Ǽ�','33-���Ӿ���ֵ',
                          '34-˧��ֵ','35-��ѫֵ','36-�лᾭ��','37-�л�ս�쾭��','38-�л���˹��׶�',
                          '127-�Զ��影��'
                           );
  RoleCondModeStr   : array [0..14] of string
                        = (
                          '0-Ҫ������N��', '1-Ҫ����ɵȼ�', '2-Ҫ��ְҵ', '3-Ҫ������', '4-���ڳ���',
                          '5-ɱ¾ֵ', '6-ս��ֵ', '7-����ǰ��������ɵ�����', '8-����Я����Ʒ', '9-��Ʒ����',
                          '10-��Ӧ����ID', '11-����������Ҫ��', '12-֧������ǰ������', '13-�Ա����ƣ�id(0�У�1Ů)' ,'14-��������Ψһ'
                           );
  RoleNeedModeStr   : array [TRoleNeedsMode] of string
                        = ('��', '��Ʒ', '����', 'Ԫ��');

  RoleJobStr : array[TRoleJob] of string = ('������','�½�','��ı','����','����');
  MoneyTypeStr : array [0..3] of string = ('���','���','��ȯ','Ԫ��');
type
  TIntegerArray = array of Integer;

  TCustomEnvirObject = class
  private
    m_sName: WideString;
    m_Position: TPoint;
  public
    destructor Destroy();override;

    property Name: WideString read m_sName;
    property Position: TPoint read m_Position;
  end;

  TEnvirNPC = class(TCustomEnvirObject)
  private
    m_sScript: string;
  public
    NPCLangID: Integer;
    NpcID: Integer;
    NpcName : string;
    property Script: string read m_sScript;
  end;

  TEnvirMonster = class(TCustomEnvirObject)
    MonsterId: Integer;
    MonLangid: integer;
  end;

  TRoleEnvir = class
  private
    m_sMapName: WideString;
    M_MapNameLangid : Integer;
    m_nMapId  : Integer;
    m_NPCList : TStringList;
    m_MonList : TStringList;
    procedure ClearListObjects(AStringList: TStrings);
    function GetMonster(const sMonName: string): TEnvirMonster;
  public
    constructor Create();
    destructor Destroy();override;
    function GetNPC(const sNPCName: string):TEnvirNPC;
    function Getobject(const langid: Integer): Tobject;
    property MapName: WideString read m_sMapName;
    property MapLangid  : Integer read M_MapNameLangid;
    property MapId  : Integer read m_nMapId;
    property NPCList : TStringList read m_NPCList;
    property MonList : TStringList read m_MonList;
  end;

  PTSkill = ^TSkill;
  TSkill = record
    nId: Integer;//����ID
    sName: String[27];
  end;

  TCloneNode = record
    RoleId: Integer;
    AwardId: Integer;
    CopyArray: TIntegerArray;
  end;

  TfrmMain = class(TForm)
    ListView1: TListView;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ImageList3: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    PopupMenu1: TPopupMenu;
    I1: TMenuItem;
    L1: TMenuItem;
    I2: TMenuItem;
    Splitter1: TSplitter;
    ImageList4: TImageList;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    R1: TMenuItem;
    D1: TMenuItem;
    N3: TMenuItem;
    O1: TMenuItem;
    N1: TMenuItem;
    C1: TMenuItem;
    R2: TMenuItem;
    ADOQuery1: TADOQuery;
    Panel1: TPanel;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TreeView1: TTreeView;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    LabeSearchMode: TLabel;
    RadioGroupSearchMode: TRadioGroup;
    Edit1: TEdit;
    ButtonSearch: TButton;
    GroupBox1: TGroupBox;
    ListViewSearchResult: TListView;
    TabSet1: TTabSet;
    SaveDialog1: TSaveDialog;
    N4: TMenuItem;
    P1: TMenuItem;
    N5: TMenuItem;
    ToolButton13: TToolButton;
    ADOConnection1: TADOConnection;
    ToolButton14: TToolButton;
    ToolButton16: TToolButton;
    PopupMenu3: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    NPC1: TMenuItem;
    N9: TMenuItem;
    ToolButton15: TToolButton;
    btn1: TToolButton;
    btBatchUPdate: TToolButton;
    btnInherited: TToolButton;
    N6: TMenuItem;
    procedure N6Click(Sender: TObject);
    procedure btBatchUPdateClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure NPC1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure ListView1DblClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure ListView1Edited(Sender: TObject; Item: TListItem; var S: string);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure I2Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure R2Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure RadioGroupSearchModeClick(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ListViewSearchResultDblClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnInheritedClick(Sender: TObject);
  private
    { Private declarations }
    m_CurTreeNode : TTreeNode;
    m_BackList    : TList;
    m_FrtList     : TList;
    IsReadOnly: Boolean;
    m_CopyedIdArray: TIntegerArray;
    sCBPFileDir: string;
    function GetXMLValue(FNode,Node: IXMLDOMNode): string;
    function GetXMLNode(Node: IXMLDOMNode): string;
    procedure PublishCBP;
    procedure PublishLUA;

    function  DoMsgBox(const sText, sCap: string; const Flags: Integer):Integer;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    function  UpDateDocument():Boolean;
    function  LoadRoles():Boolean;
    function  ReadRoles(): Boolean;
    procedure ConfimStatId();
    function  LoadDBItems():Integer;
    function  LoadDBMonsters():Integer;
    function  RefreshRoleClass():Boolean;
    procedure ReadXmlNode(const Node: IXMLDOMNode; const Tree: TTreeNode);
    procedure RefCurrentRoleClass();
    procedure ReSetTreeView();
    function  GetRoleClass(const Tree: TTreeNode):IXMLDOMNode;
    function  GetTreeNodeFromListView(const Item: TListItem):TTreeNode;
    function  HasRoleNameInCurClass(const s: string):Boolean;
    function  FindRoleInClass(const SourceClass: IXMLDOMNode;
      const sRoleName: string):IXMLDOMNode;
    function  RoleCanbeDelete(const nRoleId: Integer):Boolean;
    function  ClassCanbeDelete(const ClassNode: IXMLDOMNode):Boolean;
    procedure GotoRoleClass(const Tree: TTreeNode);
    procedure AddToBack(const Tree: TTreeNode);
    procedure AddToFront(const Tree: TTreeNode);
    function  FindChildNode(const Tree: TTreeNode; const sText: string;
      const nType: Integer):TTreeNode;
    function  AddNewRoleClass(const ParentNode: IXMLDOMNode;
      const sClassName: string):IXMLDOMNode;
    function  AddNewRole(const RoleClass: IXMLDOMNode; const nRoleId: Integer;
      const sRoleName: string):IXMLDOMNode;
    procedure BuildRoleRelationTree();
    procedure CleanEnvirInfo();
    function LoadEnvirInfo(): Integer;
    procedure EditRole(const nRoleId: Integer;ListView: TListView);
    procedure DisplaySearchResult(const Nodes: IXMLDOMNodeList);
    procedure DisplaySearchAwardResult(const Nodes: IXMLDOMNodeList);
    procedure SearchByNPC(const Pname,NodeName,sNPC: string);
    procedure SearchByID(const nId: Integer);
    function SearchByID2(const nId: Integer):IXMLDOMNode;
    procedure SearchByMap(const sMap: string);
    procedure SearchByName(const sName: string);
    procedure SearchRoleAward(const Award: string);
    procedure SearchAwardItems(const Items: string);
    function IsDocumentOpened(): Boolean;
    procedure SetDocumentOpened(boOpened: Boolean);
    procedure GetMagicSkills;
    procedure SetCountrysExecuteId;
    procedure BatchUpdateAword;
    procedure BatchUpdateRoleDescribe(bOption: Boolean);
    function GetNPCMonData(strText: string; strList: TStrings): Boolean;
    procedure CloneRole(CloneRoleID: Integer);
    //��ȡini����
    procedure ReadConfigIni();
    procedure GenLuaCBPFile(sParam: string);
    procedure OutInheritedText( const nId: Integer);
    procedure publishWebFile;
  public
    { Public declarations }
    m_Xml       : IXMLDOMDocument;
    m_MainNode  : IXMLDOMNode;
    m_DBItems   : TStrings;
    m_DBMonsters: TStrings;
    m_ArrayMonsters: array of WideString;
    m_XMLSkills : TStrings;
    m_MapList   : TStringList;
    m_MonItems  : TMonItemReader;
    m_Countrys  : TStrings;
    m_ALlNPCList   : TStringList;
    InheritedList :TStrings;
    m_ALlNPC   : TStringList;
     m_SearchMapList: TList;
    m_SearchMonList: TList;
    m_SearchItemOfMonNameList: TStrings;
    m_Skills: array of TSkill;
    function  SaveRoleFile():Boolean;
    function  GetItemName(const nIndex: Integer):String;
    function  GetSkillName(const nIndex: Integer):String;
    function  GetCountrysName(const nIndex: Integer):String;
    function  AllocRoleId(BRepeat:Boolean=False; TrushID:Integer=0):Integer;
    function  GetMonsterNameEx(const nIndex: Integer):WideString;
    function GetMapNPCOrMonster(const nMapId: Integer; const langid: Integer): tobject;
    function  GetMonsterName(const MonID: Integer):WideString;
    function  GetMonLangid(const MonID: Integer):Integer;
    function  GetMonsterID(const MonsterName: string):Integer;
    function  GetRoleNodeById(const RoleId: Integer):IXMLDOMNode;
    function  GetMap(const sMapName: string):TRoleEnvir;overload;
    function  GetMap(const nMapId: Integer):TRoleEnvir;overload;
    function GetMapByLangid(const Langid: Integer): TRoleEnvir;
    function  GetMapNPC(const sMapName, sNPCName: string):TEnvirNPC; overload;
    function  GetMapNPC(const nMapId: Integer; const sNPCName: string):TEnvirNPC; overload;
    function GetMapNPCByLandid(const Langid: Integer;const sNPCName: string): TEnvirNPC;
    function  GetMapMonster(const sMapName, sMonName: string):TEnvirMonster; overload;
    function  GetMapMonster(const sMapID: Integer; sMonName: string):TEnvirMonster; overload;
    function GetMonsterLocations(const sMonName: string; MapList: TList; MonList: TList): Integer;
    function  GetNPCScript(const sMapName, sNpcName: string):string;overload;
    function  GetNPCScript(const nMapId: Integer; const sNpcName: string):string;overload;
    procedure EditTextFile(const sFileName: string);
    function GetRoleNeedDetail(btExecMode: TRoleExecuteMode; nExecId: Integer;
      out NeedMap: TRoleEnvir; out NeedMon: TEnvirMonster): Boolean;
    function GetRoleNeedLocationStr(btExecMode: TRoleExecuteMode; nExecId: Integer): string;
    function GetNPCName(iLangID: Integer): string;
    function GetNPCLangName(iLangID: Integer): WideString;
    function GetNPCLangID(sNpcName: string): Integer;
    function GetJobName(iJob: Integer): string;
  end;

var
  frmMain: TfrmMain;
  G_CbpPath: string; //cbp�ļ�����·��
  g_UserName: string;
  G_DataPath: string;
  IsKeepLanguage: Boolean;//�Ƿ��סѡ������
  g_LanguageName: string; //��ǰ��ǰ����
  bJustGO : Boolean;  //��������cbp�Ŀ�ݲ���
  DocumentName:string;
  m_CopyCondNode: TCloneNode;
  m_CopyTargetNode: TCloneNode;
  m_CopySurpriseNode: TCloneNode;
  m_CopyAwardNode: TCloneNode;
  m_CopyMutiAwardNode: TCloneNode;
  Bshowid: boolean;
function GetRoleCondModeStr(const index: Integer):string;
function GetRoleNeedModeStr(const NeedMode: TRoleNeedsMode):string;
function GetRoleItemModeStr(const index: Integer):string;
function GetRoleAwardModeStr(const index: Integer):string;
function FilterMonName(sName: string):string;
function GetRoleCustomItemStr(s: string): string;
function GetChildNodeLangText(Element: IXMLDOMElement;
  ChildNodeName: string): string;
procedure SetChildNodeLangText(Element: IXMLDOMElement; ChildNodeName,Text: string);
procedure SetAttrLangText(Element: IXMLDOMElement; AttrName, Text: string);
function GetAttrLangText(Element: IXMLDOMElement; AttrName: string): WideString;
function GetPCNPCName(Element: IXMLDOMNode; AttrName: string): WideString;
procedure SetPCNPCName(Element: IXMLDOMNode; AttrName, NpcName: string);
function GetStrLocations(REMode: TRoleExecuteMode;sLocations: WideString): WideString;
function SetStrLocations(REMode: TRoleExecuteMode;sLocations: string): string;
function TryGetAttrValue(Element: IXMLDOMElement; AttrName: string): Variant;
procedure CopyNodeText(ENode: IXMLDOMElement;sName: string);
function GetLuaBoolStr(value: Boolean): string;overload;
function GetLuaBool(value: Boolean): integer;
function GetBoolbyLua(value: integer): boolean;

implementation

uses MXML, UnitRoleEdit, UnitViewRole, UnitRoleRelation, UnitGenRoleAdt,
  UnitSelLocation, UnitBatchSetAward, UnitLangPackage, uDocStateCheck, IniFiles,
  UnitSettings, UnitSelectLanguages;

const
  RoleInfoXMLNodePathDataTypes : array [0..82] of TXBPNodeDesc =
  (
    (NodePath: RoleMainSecName + '.' + RoleSecName; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleIdAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleNameAtbName; DataType: lfstring; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleKindAttrName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleNeedLevel; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + circleAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + maxcirAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleWayfindingByDriver; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleDescSecName; DataType: lfstring; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + entrustAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + guideIdAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + speedYbAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleIntervalValue; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleInheritedAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAbortable; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleTimeValue; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + ExcludeChilds; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + randomTargetAttr; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAutoTransmitAttrName; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAutoCompleteAttrName; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleMaxTimeAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + starAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + multiAwardAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + DoubleMoneyTypeAttr; DataType: lfnumber; NameType: pntSource),


    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + PromAttr; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + PromAttr + '.' + PromtypeAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + PromAttr + '.' + RolePromulgationMap; DataType: lfString; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + PromAttr + '.' + RolePromulgationNPC; DataType: lfString; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + PromAttr + '.' + PromisFPAttr; DataType: lfnumber; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + CompAttr; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + CompAttr + '.' + ComptypeAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + CompAttr + '.' + RoleAcceptMap; DataType: lfString; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + CompAttr + '.' + RoleAcceptNPC; DataType: lfString; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + CompAttr + '.' + CompisFPAttr; DataType: lfnumber; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleConditionS; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleConditionS + '.' + RoleCondition; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleConditionS + '.' + RoleCondition + '.' + CondtypeAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleConditionS + '.' + RoleCondition + '.' + CondidAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleConditionS + '.' + RoleCondition + '.' + CondCountAttr; DataType: lfnumber; NameType: pntSource),
    //�౶����
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + MultiAwardTable; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + MultiAwardTable + '.' + MultiAwardSTable; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + MultiAwardTable + '.' + MultiAwardSTable + '.' + MAMoneyTypeAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + MultiAwardTable + '.' + MultiAwardSTable + '.' + MARateAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + MultiAwardTable + '.' + MultiAwardSTable + '.' + MAmoneyCountAttr; DataType: lfnumber; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AWardItemIdAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + jobAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + sexAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AWardItemBindAtbName; DataType: lfString; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AwardModeAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AWardCountAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + groupAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AWardStrongAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + datastrAttr; DataType: lfstring; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + AWardQualityAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + ringRateAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + vipLevelAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + bossLevelAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + levelRateAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleAwardsSecName + '.' + AwardTagAttr + '.' + RoleAwardSecName + '.' + importantLevelAttr; DataType: lfnumber; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName; DataType: lfTable; NameType: pntindex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + ItemExecIdAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + ItemExecModeAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + ItemNeedCountAtbName; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + useListAttr; DataType: lfbool; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + rewardIdAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + dataAttr; DataType: lfstring; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + locationXAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + locationYAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + sceneidAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + entityNameAttr; DataType: lfstring; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + hideFastTransferAttr; DataType: lfbool; NameType: pntSource),

    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr; DataType: lfTable; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr + '.' + PassAttr; DataType: lfTable; NameType: pntIndex),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr + '.' + PassAttr + '.' + xAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr + '.' + PassAttr + '.' + yAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr + '.' + PassAttr + '.' + PasssceneidAttr; DataType: lfnumber; NameType: pntSource),
    (NodePath: RoleMainSecName + '.' + RoleSecName + '.' + RoleItemsSceName + '.' + RoleItemSecName + '.' + locationesAttr + '.' + PassesAttr + '.' + PassAttr + '.' + PassentityNameAttr; DataType: lfstring; NameType: pntSource)

  );

{$R *.dfm}

function GetBoolbyLua(value: integer): boolean;
begin
  result := value > 0;
end;

function GetLuaBool(value: Boolean): integer;
begin
  if value then result := 1 else result := 0;
end;

function GetLuaBoolStr(value :Boolean):string;
begin
  Result := LowerCase(BoolToStr(value, True))
end;


procedure CopyNodeText(ENode: IXMLDOMElement;sName: string);
var
  sValue: string;
  nLang: Integer;
begin
  sValue := ENode.getAttribute(sName);
  if sValue <> '' then
  begin
    TryStrToInt(sValue,nLang);
    ENode.setAttribute(sName,LanguagePackage.AddLangText(RoleLangCategoryId,LanguagePackage.GetLangText(RoleLangCategoryId,nLang)));
  end;
end;

function TryGetAttrValue(Element: IXMLDOMElement; AttrName: string): Variant;
var
  AttrNode: IXMLDOMNode;
begin
  if AttrName = sexAttr then
   Result := 2
  else
   Result := 0;
  AttrNode := Element.attributes.getNamedItem(AttrName);
  if (AttrNode <> nil) and (Trim(AttrNode.nodeValue) <> '') then
  begin
    Result := AttrNode.nodeValue;
  end
  else
  begin
   Exit;
  end;
end;


function GetSpaceString(sMsg: WideString;var sData: WideString): WideString;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(':',sMsg);
  if iPos <> 0 then
  begin
    Result := Copy(sMsg,iPos+1,Length(sMsg));
    sData := Copy(sMsg,1,iPos-1);
  end
  else begin
    if sMsg <> '' then
    begin
      Result := '';
      sData := sMsg;
    end;
  end;
end;

function GetStrLocations(REMode: TRoleExecuteMode;sLocations: WideString): WideString;
var
  S,sMapId,sX,sY,sMon,sSign: WideString;
begin
  Result := sLocations;
  S := GetSpaceString(sLocations,sMapId);
  if sMapId <> '' then
  begin
    Result := frmMain.GetMap(StrToInt(sMapId)).MapName;
  end;
  S := GetSpaceString(S,sX);
  if sX <> '' then
  begin
    Result := Result + ':' +sX;
  end;
  S := GetSpaceString(S,sY);
  if sY <> '' then
  begin
    Result := Result + ':' +sY;
  end;
  S := GetSpaceString(S,sMon);
  S := GetSpaceString(S,sSign);
  if sMon <> '' then
  begin
    if (REMode = reCustom) or (sSign = '1') then
    begin
      Result := Result + ':' + frmMain.GetNPCLangName(StrToInt(sMon));
    end
    else begin
      Result := Result + ':' + frmMain.GetMonsterNameEx(StrToInt(sMon));
    end;
  end;
  if sSign <> '' then
  begin
    Result := Result + ':' + sSign;
  end;
end;

function SetStrLocations(REMode: TRoleExecuteMode;sLocations: string): string;
var
  tmpList: TStringList;
  nId: Integer;
  RoleEnvir: TRoleEnvir;
begin
  Result := '';
  tmpList := TStringList.Create;
  try
    tmpList.Delimiter := ':';
    tmpList.DelimitedText := sLocations;
    if tmpList.Count > 0 then
    begin
      if Trim(tmpList.Strings[0]) <> '' then
      begin
        RoleEnvir := frmMain.GetMap(tmpList.Strings[0]);
        if RoleEnvir = nil then Exit;
        tmpList.Strings[0] := IntToStr(RoleEnvir.MapId);
      end;
      // �������õ���ͼid
    end;
    if tmpList.Count > 3 then
    begin
      // �����õ�����ID
      if Trim(tmpList.Strings[3]) <> '' then
      begin
        if REMode = reCustom then
        begin
          nId := frmMain.GetNPCLangID(tmpList.Strings[3]);
        end
        else begin
          // ����4����Ϊ�ֶ������ֵ ������npc��֧�� 0:���1��npc;
          if tmpList.Count > 4 then
          begin
           if Trim(tmpList.Strings[4]) = '0' then
            nId := frmMain.GetMonsterId(tmpList.Strings[3])
           else if Trim(tmpList.Strings[4]) = '1' then
            nId := frmMain.GetNPCLangID(tmpList.Strings[3]);
          end
          else begin
           nId := frmMain.GetMonsterId(tmpList.Strings[3]);
          end;
        end;
        if nId = -1 then Exit;
        tmpList.Strings[3] := IntToStr(nId);
      end;
    end;
    Result := tmpList.DelimitedText;
  finally
    tmpList.Free;
  end;
end;

//function GetRoleItemModeStr(const ExecMode: TRoleExecuteMode):string;
//begin
//  Result := RoleExecuteModeStr[ExecMode];
//end;

function GetRoleItemModeStr(const index: Integer):string;
begin
  if index = 127 then
   Result := RoleExecuteModeStr[length(RoleExecuteModeStr)-2]
  else if index = 256 then
   Result := RoleExecuteModeStr[length(RoleExecuteModeStr)-1]
  else
   Result := RoleExecuteModeStr[index];
end;

function GetRoleAwardModeStr(const index: Integer):string;
begin
  Result := RoleAwardModeStr[index];
end;

function GetRoleCondModeStr(const index: Integer):string;
begin
  Result := RoleCondModeStr[index];
end;

function GetRoleNeedModeStr(const NeedMode: TRoleNeedsMode):string;
begin
  Result := RoleNeedModeStr[NeedMode];
end;

function FilterMonName(sName: string):string;
var
  I, ALen, ACopy: Integer;
begin
  ALen := Length(sName);
  ACopy:= ALen;
  for I := ALen downto 1 do
  begin
    if sName[I] in ['0'..'9'] then
    begin
      Dec( ACopy );
    end
    else break;
  end;
  if ACopy <> ALen then
    Result := Copy( sName, 1, ACopy )
  else Result := sName;
end;

function GetRoleCustomItemStr(s: string): string;
var
  nPos: Integer;
begin
  nPos := Pos( ')', s );
  if nPos > 0 then
  begin
    Result := Copy(S, nPos + 1, Length(s) - nPos );
  end
  else Result := s;
end;  

procedure SetChildNodeLangText(Element: IXMLDOMElement; ChildNodeName,
  Text: string);
var
  ChildNode: IXMLDOMNode;
begin
  ChildNode := Element.selectSingleNode(ChildNodeName);
  if ChildNode <> nil then
  begin
    LanguagePackage.ReplaceLangText(RoleLangCategoryId, StrToInt(ChildNode.text),Text);
  end
  else begin
    ChildNode := frmMain.m_Xml.createElement(ChildNodeName);
    ChildNode.text := IntToStr(LanguagePackage.AddLangText(RoleLangCategoryId, Text));
    Element.appendChild(ChildNode);
  end;
end;


function GetChildNodeLangText(Element: IXMLDOMElement;
  ChildNodeName: string): string;
var
  ChildNode: IXMLDOMNode;
begin
  ChildNode := Element.selectSingleNode(ChildNodeName);
  if ChildNode <> nil then
  begin
    Result := LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(ChildNode.text));
  end
  else begin
    Result := '';
  end;
end;

procedure SetAttrLangText(Element: IXMLDOMElement; AttrName,
  Text: string);
var
  AttrNode: IXMLDOMNode;
begin
  if Text = '' then
  begin
      Element.setAttribute(AttrName, '')
  end
  else
  begin
    AttrNode := Element.attributes.getNamedItem(AttrName);
    if (AttrNode <> nil) and (Trim(AttrNode.nodeValue) <> '') then
    begin
      LanguagePackage.ReplaceLangText(RoleLangCategoryId, AttrNode.nodeValue,Text);
    end
    else begin
      Element.setAttribute(AttrName, LanguagePackage.AddLangText(RoleLangCategoryId, Text));
    end;
  end;
end;

function GetAttrLangText(Element: IXMLDOMElement; AttrName: string): WideString;
var
  AttrNode: IXMLDOMNode;
begin
  AttrNode := Element.attributes.getNamedItem(AttrName);
  if (AttrNode <> nil) and (Trim(AttrNode.nodeValue) <> '') then
  begin
    Result := LanguagePackage.GetLangText(RoleLangCategoryId, AttrNode.nodeValue);
  end
  else begin
    Result := '';
  end;
end;

function GetPCNPCName(Element: IXMLDOMNode; AttrName: string): WideString;
var
  nLId : Integer;
begin
  nLId := (Element as IXMLDOMElement).getAttribute(AttrName);
  if nLId < 0 then
  begin
    if nLid = ROLE_NPC_AUTO_PROMULGATE_ID then
      Result := ROLE_AUTO_PROMULGATE
    else if nLid = ROLE_NPC_ITEM_PROMULGATE_ID then
      Result := ROLE_ITEM_PROMULGATE
    else if nLid = ROLE_NPC_AUTO_COMPLETE_ID then
      Result := ROLE_AUTO_COMPLATE
    else Result := '';
  end
  else Result := LanguagePackage.GetLangText(RoleLangCategoryId, nLId);
end;

procedure SetPCNPCName(Element: IXMLDOMNode; AttrName, NpcName: string);
begin
  if NpcName = ROLE_AUTO_PROMULGATE then
    (Element as IXMLDOMElement).setAttribute(AttrName, ROLE_NPC_AUTO_PROMULGATE_ID)
  else if NpcName = ROLE_ITEM_PROMULGATE then
    (Element as IXMLDOMElement).setAttribute(AttrName, ROLE_NPC_ITEM_PROMULGATE_ID)
  else if NpcName = ROLE_AUTO_COMPLATE then    
    (Element as IXMLDOMElement).setAttribute(AttrName, ROLE_NPC_AUTO_COMPLETE_ID)
  else SetAttrLangText(Element as IXMLDOMElement, AttrName, NpcName);
end;

function TfrmMain.AddNewRole(const RoleClass: IXMLDOMNode;
  const nRoleId: Integer; const sRoleName: string): IXMLDOMNode;
var
  Node: IXMLDOMNode;
  TempEle: IXMLDOMElement;
begin
  Result := nil;
  if RoleClass = nil then Exit;
  Node  := m_Xml.createElement(RoleSecName);
  with (Node as IXMLDOMElement) do
  begin
    setAttribute(RoleIdAtbName, nRoleId);
    setAttribute(RoleNameAtbName, LanguagePackage.AddLangText(RoleLangCategoryId, sRoleName));
    setAttribute(RoleInheritedAtbName, defint);
    setAttribute(RoleNeedLevel, defint);
    setAttribute(RoleMaxTimeAtbName, 1);
    setAttribute(RoleTimeValue, Int64(defint));
    setAttribute(RoleIntervalValue, Int64(defint));
    setAttribute(ExcludeChilds, defBool);
    setAttribute(entrustAttr, defint);
    setAttribute(maxcirAttr, defint);
    setAttribute(circleAttr, defint);
    setAttribute(guideIdAttr, defint);
    setAttribute(speedYbAttr, defint);
    setAttribute(RoleKindAttrName, defint);
    setAttribute(RoleAutoTransmitAttrName, defBool);
    setAttribute(RoleAutoCompleteAttrName, defBool);
    setAttribute(automountAttr, defBool);  //�������Զ�������
    setAttribute(RoleAbortable, defBool);  //�������Զ�������
    setAttribute(RoleWayfindingByDriver, 'true');//��������Զ�Ѱ·
    setAttribute(randomTargetAttr, defbool);//��������Զ�Ѱ·
    setAttribute(notGiveAwardAttr, defbool);//��������Զ�Ѱ·
//    setAttribute(doubleYBAttr, 'false');
    setAttribute(DoubleMoneyTypeAttr, 3);
    setAttribute(AgainMoneyTypeAttr, 3);
    setAttribute(entrustAttr, defint);
    setAttribute(multiAwardAttr, 2);
    setAttribute(starAttr, defint);
    appendChild(m_Xml.createElement(RoleItemsSceName));
    appendChild(m_Xml.createElement(RoleAwardsSecName));
    appendChild(m_Xml.createElement(RoleConditionS));
    appendChild(m_Xml.createElement(surpriseAwardTable));
    appendChild(m_Xml.createElement(MultiAwardTable));
    TempEle := m_Xml.createElement(PromAttr);
    TempEle.setAttribute(PromisFPAttr, defint);
    appendChild(TempEle);
    TempEle := m_Xml.createElement(CompAttr);
    TempEle.setAttribute(CompisFPAttr, defint);
    appendChild(TempEle);
  end;
  Result := RoleClass.appendChild(Node);
  if Result <> nil then SaveRoleFile();
end;

function TfrmMain.AddNewRoleClass(const ParentNode: IXMLDOMNode;
  const sClassName: string): IXMLDOMNode;
begin
  Result := nil;
  if ParentNode = nil then
    Exit;
  Result := m_Xml.createElement(RoleClassSecName);
  (Result as IXMLDOMElement).setAttribute(RoleClassNameAtbName,
    LanguagePackage.AddLangText(RoleLangCategoryId, sClassName));
  Result := ParentNode.appendChild(Result);
  if Result <> nil then
    SaveRoleFile();
end;

procedure TfrmMain.AddToBack(const Tree: TTreeNode);
begin
  if m_BackList.Count > 0 then
    if m_BackList.Items[m_BackList.Count - 1] = Tree then
      Exit;
  m_BackList.Add(Tree);
end;

procedure TfrmMain.AddToFront(const Tree: TTreeNode);
begin
  if m_FrtList.Count > 0 then
    if m_FrtList.Items[m_FrtList.Count - 1] = Tree then
      Exit;
  m_FrtList.Add(Tree);
end;

function TfrmMain.AllocRoleId(BRepeat:Boolean; TrushID:Integer): Integer;
Resourcestring
  sQueryText  = RoleStatSecName;
var
  Node: IXMLDOMNode;
begin
  Result := 0;
  if m_MainNode = nil then Exit;

  if BRepeat then
  begin
    Node := m_MainNode.selectSingleNode( RoleRecycleResScName + '/' + TrushRepeatName );
    if Node <> nil then
    begin
      Result := (Node as IXMLDOMElement).getAttribute(TrushIdAttrName);
      Node.parentNode.removeChild( Node );
    end
    else
    begin
      Node  := m_MainNode.selectSingleNode(sQueryText);
      if Node = nil then Exit;
      Node  := Node.attributes.getNamedItem(StatRepeatId);
      if Node = nil then Exit;
      Result := Node.nodeValue;
      Node.nodeValue  := Node.nodeValue + 1;
    end;
  end
  else
  begin
    Node := m_MainNode.selectSingleNode( RoleRecycleResScName + '/' + TrushSecName );
    if Node <> nil then
    begin
      Result := (Node as IXMLDOMElement).getAttribute(TrushIdAttrName);
      Node.parentNode.removeChild( Node );
    end
    else
    begin
      Node  := m_MainNode.selectSingleNode(sQueryText);
      if nil = Node then Exit;
      Node  := Node.attributes.getNamedItem(StatNewRoleId);
      if Node = nil then Exit;
      Result := Node.nodeValue;
      Node.nodeValue  := Node.nodeValue + 1;
    end;
  end;

  if TrushID<>0 then
  begin
    if (TrushID <= 0) or (TrushID >= RepeatStartID) then
    begin
      with m_MainNode.selectSingleNode(RoleRecycleResScName).appendChild( m_Xml.createElement(TrushRepeatName) )
      as IXMLDOMElement do
      begin
        setAttribute( TrushIdAttrName, TrushID );
      end;
    end
    else
    begin
      with m_MainNode.selectSingleNode(RoleRecycleResScName).appendChild( m_Xml.createElement(TrushSecName) )
      as IXMLDOMElement do
      begin
        setAttribute( TrushIdAttrName, TrushID );
      end;
    end;

  end;
  



  SaveRoleFile();
end;

procedure TfrmMain.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  ToolButton1.Enabled := m_BackList.Count > 0;
  ToolButton2.Enabled := m_FrtList.Count > 0;
  ToolButton4.Enabled := (m_CurTreeNode <> nil) and (m_CurTreeNode.Parent <> nil);
end;

procedure TfrmMain.BuildRoleRelationTree;
var
  frmRoleRelation: TfrmRoleRelation;
  Doc : IXMLDOMDocument;
  MainNode: IXMLDOMNode;
  ParentRoleList: IXMLDOMNodeList;
  I: Integer;
  procedure MakeChildRelations(ParentNode, RoleNode : IXMLDOMNode;
    ParentTreeNode: TTreeNode );
  var
    ChildRoles: IXMLDOMNodeList;
    NewNode: IXMLDOMNode;
    NewTreeNode: TTreeNode;
    N: Integer;
    sRoleId, sRoleName: string;
  begin
    NewNode := ParentNode.appendChild( Doc.createElement( 'Role' ) );
    sRoleId := RoleNode.attributes.getNamedItem(RoleIdAtbName).text;
    sRoleName := LanguagePackage.GetLangText(RoleLangCategoryId, RoleNode.attributes.getNamedItem(RoleNameAtbName).nodeValue);
    with NewNode as IXMLDOMElement do
    begin
      setAttribute( 'ID', sRoleId );
      setAttribute( 'Name', sRoleName );
    end;

    NewTreeNode := frmRoleRelation.TreeView1.Items.AddChild( ParentTreeNode,
      sRoleName + '(' + sRoleId + ')' );
    NewTreeNode.Data := Pointer(StrToInt(sRoleId));
    if ParentTreeNode <> nil then
      ParentTreeNode.Expanded := True;
      
    ChildRoles := m_MainNode.selectNodes( '//' + RoleSecName +
      '[@' + RoleInheritedAtbName + '=''' +
      RoleNode.attributes.getNamedItem(RoleIdAtbName).text +
      ''']');
      
    for N := 0 to ChildRoles.length - 1 do
    begin
      MakeChildRelations( NewNode, ChildRoles.item[N], NewTreeNode );
    end;
    
  end;
begin
  frmRoleRelation := TfrmRoleRelation.Create( nil );

  Doc := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument;
  Doc.appendChild(Doc.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"'));
  Doc.appendChild(Doc.createComment(' 5e2.0 �����ϵ '));
  MainNode := Doc.appendChild(Doc.createElement('RoleRelationTree'));

  ParentRoleList := m_MainNode.selectNodes( '//' + RoleSecName +
    '[@' + RoleInheritedAtbName + '=''0'']' );
  for I := 0 to ParentRoleList.length - 1 do
  begin
    MakeChildRelations( MainNode, ParentRoleList.item[I], nil );
  end;
  Doc.save('./RoleRelation.xml');
  Doc := nil;
  ShowMessage( '�������.�����ϵ�����Ѿ�������RoleRelation.xml��.' );
  
  frmRoleRelation.ShowModal();
  frmRoleRelation.Free;
end;

procedure TfrmMain.ButtonSearchClick(Sender: TObject);
begin
  case RadioGroupSearchMode.ItemIndex of
    0: SearchByID( StrToInt(Edit1.Text) );
    1: SearchByName( Edit1.Text );
    2: SearchByMap( Edit1.Text );
    3: SearchByNPC( PromAttr,RolePromulgationNPC, Edit1.Text );
    4: SearchByNPC( CompAttr,RoleAcceptNPC, Edit1.Text );
    5: SearchRoleAward( Edit1.Text );
    6: SearchAwardItems( Edit1.Text );
  end;
end;

procedure TfrmMain.C1Click(Sender: TObject);
Resourcestring
  sNewNameBegin = '�½�������� ';
var
  LangID: Integer;
  sName: string;
  ClassNode,Node : IXMLDOMNode;
  function GetNewName():string;
  var
    nIdx : Integer;
  begin
    nIdx  := 1;
    while true do
      begin
        Result := sNewNameBegin + IntToStr(nIdx);
        if FindChildNode(m_CurTreeNode, Result, 0) = nil  then
          break;
        Inc(nIdx);
      end;
  end;
begin
  sName := GetNewName();
  Node  := GetRoleClass(m_CurTreeNode);
  ClassNode := AddNewRoleClass(Node, sName);
  if ClassNode = nil then
    Exit;
  LangID := ClassNode.attributes.getNamedItem(RoleClassNameAtbName).nodeValue;
  with TreeView1.Items.AddChild(m_CurTreeNode, sName) do
    begin
      ImageIndex    := 0;
      SelectedIndex := 0;
      Data          := Pointer(LangID);
    end;
  with ListView1.Items.Add do
    begin
      Caption := sName;
      ImageIndex  := 0;
      SubItems.AddObject('����', TObject(0));
      SubItems.AddObject('', nil);
      EditCaption;
    end;
end;

function TfrmMain.ClassCanbeDelete(const ClassNode: IXMLDOMNode): Boolean;
Resourcestring
  sQueryText  = RoleSecName;
var
  I: Integer;
  NodeList: IXMLDOMNodeList;
  Node: IXMLDOMNode;
begin
  Result := False;
  if ClassNode = nil then
    Exit;
  NodeList  := ClassNode.selectNodes(sQueryText);
  Result := True;
  for I := 0 to NodeList.length - 1 do
    begin
      Node  := NodeList.item[I];
      if not RoleCanbeDelete(Node.attributes.getNamedItem(RoleIdAtbName).nodeValue) then
        begin
          Result := False;
          DoMsgBox(Format('���� %s ���ܱ�ɾ������Ϊ������������̳��ڴ�����!',
                          [LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue)]),
                   '����',
                   MB_ICONSTOP);
          break;
        end;
    end;
end;

procedure TfrmMain.CleanEnvirInfo;
var
  I: Integer;
begin
  for I := 0 to m_MapList.Count - 1 do
  begin
    m_MapList.Objects[I].Free;
  end;
  m_MapList.Clear;
end;

procedure TfrmMain.CloneRole(CloneRoleID: Integer);
var
  Node, ClassNode: IXMLDOMNode;
  Element : IXMLDOMElement;
  sName: string;
  I,J,nRoleId: Integer;
  NodeList,ChildList: IXMLDOMNodeList;
begin
  {$MESSAGE 'ע�����������԰�����ʱҪ������ճ����������԰�ID��Ҫ����ظ�'}
  if CloneRoleID = 0 then Exit;
  
  Node := GetRoleNodeById(CloneRoleID);
  ClassNode := Self.GetRoleClass(m_CurTreeNode);
  if (Node <> nil) and (ClassNode <> nil) then
  begin
    Element := Node.cloneNode(True) as IXMLDOMElement;
    //�ж�idҪ��Ҫ��8000��ʼ
    if TryGetAttrValue(Element, RoleKindAttrName)=0 then
      nRoleId := frmMain.AllocRoleId(False, 0)
    else
      nRoleId := frmMain.AllocRoleId(True, 0);
    Element.setAttribute( RoleIdAtbName, nRoleId );
    sName := LanguagePackage.GetLangText(RoleLangCategoryId, Element.getAttribute(RoleNameAtbName)) + ' �ĸ���';
    Element.setAttribute( RoleNameAtbName, LanguagePackage.AddLangText(RoleLangCategoryId, sName) );
    CopyNodeText(Element,RoleDescSecName);
    CopyNodeText(Element,RolePromTalkSecName);
    CopyNodeText(Element,RoleCompTalkSecName);
    CopyNodeText(Element,RoleAcceptStorySecName);
    CopyNodeText(Element,RoleFinishStorySecName);
    NodeList := Element.selectNodes(RoleItemsSceName+'/'+RoleItemSecName);
    for I := 0 to NodeList.length - 1 do
    begin
      CopyNodeText(NodeList[I] as IXMLDOMElement,dataAttr);
      CopyNodeText(NodeList[I] as IXMLDOMElement,dataMonsterAttr);
      ChildList := NodeList[I].selectNodes(locationesAttr+'/'+PassesAttr+'/'+PassAttr);
      for J := 0 to ChildList.length - 1 do
      begin
        CopyNodeText(ChildList[J] as IXMLDOMElement,actionDescAttr);
      end;
    end;
    NodeList := Element.selectNodes(RoleAwardsSecName+'/'+AwardTagAttr);
    for I := 0 to NodeList.length - 1 do
    begin
      ChildList := NodeList[I].selectNodes(RoleAwardSecName);
      for J := 0 to ChildList.length - 1 do
      begin
        CopyNodeText(ChildList[J] as IXMLDOMElement,datastrAttr);
      end;
    end;
    ClassNode.appendChild( Element );
    SaveRoleFile();
{$IF SHOWROLESINTREE}
    with TreeView1.Items.AddChild(m_CurTreeNode, sName) do
    begin
      ImageIndex    := 1;
      SelectedIndex := 1;
      Data          := Pointer(nRoleId);
    end;
{$IFEND}
    with ListView1.Items.Add do
    begin
      Caption := sName;
      ImageIndex  := 1;
      SubItems.AddObject('����', TObject(1));
      SubItems.AddObject('', TObject(nRoleId));
      EditCaption;
    end;
  end;
end;

procedure TfrmMain.ConfimStatId;
Resourcestring
  sQueryText  = '//' + RoleStatSecName;
var
  Node: IXMLDOMNode;
begin
  if m_MainNode = nil then Exit;
  Node  := m_MainNode.selectSingleNode(sQueryText);
  if nil = Node then
    Node  := m_Xml.createElement(RoleStatSecName);
  if Node.attributes.getNamedItem(StatNewRoleId) = nil then
    begin
      (Node as IXMLDOMElement).setAttribute(StatNewRoleId, 1);
      m_MainNode.appendChild(Node);
      SaveRoleFile();
    end;
end;

procedure TfrmMain.D1Click(Sender: TObject);
var
  Node: IXMLDOMNode;
  Tree: TTreeNode;
  procedure DeleteSelected();
  var
    I, nRoleId: Integer;
    Ele :IXMLDOMElement;
  begin
    for I := ListView1.Items.Count - 1 downto 0 do
    begin
      if ListView1.Items[I].Selected then
      begin
        case Integer(ListView1.Items[I].SubItems.Objects[0]) of
          0:begin
            Tree  := GetTreeNodeFromListView(ListView1.Items[I]);
            if Tree = nil then
              continue;
            Node  := GetRoleClass(Tree);
            if Node = nil then
              continue;
            if not ClassCanbeDelete(Node) then
              break;
            Tree.Delete;
            if Node.parentNode <> nil then
              Node.parentNode.removeChild(Node);
          end;
          1:begin
            Node  := GetRoleNodeById(Integer(ListView1.Items[I].SubItems.Objects[1]));
            if Node = nil then
              continue;
            if not RoleCanbeDelete(Integer(ListView1.Items[I].SubItems.Objects[1])) then
            begin
              DoMsgBox(Format('���� %s ���ܱ�ɾ������Ϊ������������̳��ڴ�����!',
                              [LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue)]),
                      '����',
                      MB_ICONSTOP);
              break;
            end;
            if Node.parentNode <> nil then
            begin
              nRoleId := (Node as IXMLDOMElement).getAttribute(RoleIdAtbName);
              Node.parentNode.removeChild(Node);
              if nRoleId >= RepeatStartID then
               Ele := m_MainNode.selectSingleNode(RoleRecycleResScName).appendChild( m_Xml.createElement(TrushRepeatName)) as IXMLDOMElement
              else
               Ele := m_MainNode.selectSingleNode(RoleRecycleResScName).appendChild( m_Xml.createElement(TrushSecName)) as IXMLDOMElement;
              with Ele do
              begin
                setAttribute( TrushIdAttrName, nRoleId );
              end;
            end;
          end;
        end;
      end;
    end;
    RefCurrentRoleClass();
    SaveRoleFile();
  end;
begin
  if ListView1.SelCount = 0 then
    Exit;
  if ListView1.SelCount = 1 then
  begin
    case Integer(ListView1.Selected.SubItems.Objects[0]) of
      0:
      if DoMsgBox(Format('ȷʵҪɾ������ %s ��?', [ListView1.Selected.Caption]), 'ȷ��', MB_ICONQUESTION or MB_YESNOCANCEL) <> ID_YES then
        Exit;
      1:
      if DoMsgBox(Format('ȷʵҪɾ������ %s ��?', [ListView1.Selected.Caption]), 'ȷ��', MB_ICONQUESTION or MB_YESNOCANCEL) <> ID_YES then
        Exit;
      else Exit;
    end;
    DeleteSelected();
  end
  else DeleteSelected();
end;

function TfrmMain.DoMsgBox(const sText, sCap: string;
  const Flags: Integer): Integer;
begin
  Result  := Application.MessageBox(PChar(sText), PChar(sCap), Flags);
end;


procedure TfrmMain.EditRole(const nRoleId: Integer;ListView: TListView);
var
  Node: IXMLDOMNode;
begin
  Node  := GetRoleNodeById(nRoleId);
  if nil = Node then
    Exit;
  with TfrmRoleEdit.Create(nil) do
  begin
    if IsReadOnly then
    begin
      ListViewAwards.OnDblClick := nil;
      ListViewAwards.PopupMenu := nil;
      lvTargets.OnDblClick := nil;
      lvTargets.PopupMenu := nil;
    end;
    curListView := ListView;
    m_curRole := ListView.Selected.Index;
    if EditRole(Node) then
      SaveRoleFile();
    Free;
  end;
end;

procedure TfrmMain.EditTextFile(const sFileName: string);
begin
  WinExec(PansiChar('notepad.exe ' + sFileName), SW_SHOW);
end;

function TfrmMain.FindChildNode(const Tree: TTreeNode;
  const sText: string; const nType: Integer): TTreeNode;
var
  I: Integer;
         begin
  Result := nil;
  if nType = 0 then
    for I := 0 to Tree.Count - 1 do
      if (Integer(Tree.Item[I].Data) = nType)
      and (CompareText(Tree.Item[I].Text, sText) = 0) then
        begin
          Result := Tree.Item[I];
          break;
        end;
  if nType = 1 then
    for I := 0 to Tree.Count - 1 do
      if (CompareText(Tree.Item[I].Text, sText) = 0) then
        begin
          Result := Tree.Item[I];
          break;
        end;
end;

function TfrmMain.FindRoleInClass(const SourceClass: IXMLDOMNode;
  const sRoleName: string): IXMLDOMNode;
Resourcestring
  sQueryText  = RoleSecName + '[@' + RoleNameAtbName + '=''%d'']';
var
  I: Integer;
  NodeList: IXMLDomNodeList;
  Element : IXMLDOMElement;
begin
  Result := nil;
  if SourceClass = nil then
    Exit;
  NodeList := SourceClass.selectNodes(RoleSecName);
  for I := 0 to NodeList.length - 1 do
  begin
    Element := NodeList[I] as IXMLDOMElement;
    if LanguagePackage.GetLangText(RoleLangCategoryId,Element.getAttribute(RoleNameAtbName)) = sRoleName then
    begin
      Result := NodeList[I];
      break;
    end;
  end;
end;

function LoadUTF(f:string;b:boolean=true):string;
var
  ms:TMemoryStream;
  s,hs:string;
begin
  Result:='';
  if not FileExists(f) then exit;
  ms:=TMemoryStream.Create;
  ms.LoadFromFile(f);
  if b then begin
    SetLength(hs,3);
    ms.Read(hs[1],3);
    if hs<>#$EF#$BB#$BF then begin ms.Free; exit; end;
    SetLength(s,ms.Size-3);
    ms.Read(s[1],ms.Size-3);
  end else begin
    SetLength(s,ms.Size);
    ms.Read(s[1],ms.Size);
  end;
  Result:=Utf8ToAnsi(s);
  ms.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  StrLanguageName: string;
  bKeppLanguage: Boolean;
begin
{$IFDEF VER180}
//  System.ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  DocStateCheck := TDocStateCheck.Create;
  LanguagePackage := TLanguagePackage.Create;
   m_Xml := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument;
  if nil = m_Xml then
  begin
    DoMsgBox('��ʼ�� DOMDocument ʧ��', '����', MB_ICONSTOP);
    Halt(0);
  end;
  with TIniFile.Create(ExtRactFilePath(ParamStr(0)) + sConfigName) do
  try
    G_CbpPath := ReadString(sMainConfigKey, sCbpPath, '');
    IsKeepLanguage    := ReadBool(sMainConfigKey, sIsKeepLanguage, False);
    g_LanguageName    := ReadString(sMainConfigKey, sLanguageName, '');
    G_DataPath        := ReadString(sMainConfigKey, sDataPath, '');
    if G_DataPath = '' then WriteString(sMainConfigKey, sDataPath, defGPath);
    if G_CbpPath = '' then WriteString(sMainConfigKey, sCbpPath, defCbpPath);

    if not ValueExists(sMainConfigKey,'BshowId') then
    begin
      WriteBool(sMainConfigKey,'BshowId',False);
    end;
    BshowId := ReadBool(sMainConfigKey,'BshowId',False);
    LanguagePackage.BShowID := Bshowid;

    g_UserName        := ReadString(sMainConfigKey, sUserName, '');
    DocumentName      := format(RolePath, [G_DataPath]);
  //��������ò����Ͷ����� ���û��������ԭ���Ķ�ȡ�����ļ�
    if ParamCount = 1 then
    begin
      SelectLanguages(LanguagePackage, StrLanguageName, StrToIntDef(ParamStr(1),-1));
      LanguagePackage.LanguageName := StrLanguageName;
      bJustGO := true;
    end
     else
    begin
      if IsKeepLanguage then
      begin
        LanguagePackage.LanguageName := g_LanguageName;
      end else
      begin
        SelectLanguages(LanguagePackage, StrLanguageName, bKeppLanguage);
        LanguagePackage.LanguageName := StrLanguageName;
        if bKeppLanguage then
        begin
          WriteString(sMainConfigKey, sLanguageName,  StrLanguageName);
          WriteBool(sMainConfigKey, sIsKeepLanguage, True);
          IsKeepLanguage := True;
        end;
      end;
    end;
  finally
    Free;
  end;
  DocStateCheck.sHostName := g_UserName;

  if not LoadRoles() then
  begin
    DoMsgBox('���������ĵ�ʧ��!', '����', MB_ICONSTOP);
    Halt(0);
  end;

  Tabset1.Left := PageControl1.Left;
  Tabset1.Top := PageControl1.Top;
  Tabset1.Width := PageControl1.Width;
  PageControl1.ActivePageIndex := 0;

  m_BackList  := TList.Create;
  m_FrtList   := TList.Create;
  m_SearchMapList := TList.Create;
  m_SearchMonList := TList.Create;
  m_SearchItemOfMonNameList := TStringList.Create;
  InheritedList := TStringList.Create;

  LanguagePackage.Initialize();
  sCBPFileDir := Format('\lang\%s\', [LanguagePackage.LanguageName]);

  m_DBItems   := TStringList.Create;
  LoadDBItems();
  m_DBMonsters:= TStringList.Create;
  LoadDBMonsters();
  m_XMLSkills := TStringList.Create;
//  GetMagicSkills();

  m_MapList := TStringList.Create;
  m_ALlNPCList := TStringList.Create;
  m_ALlNPC := TStringList.Create;
  m_MapList.CaseSensitive := False;
  m_MapList.Sorted := True;
  LoadEnvirInfo();
  m_MonItems := TMonItemReader.Create;
//  m_MonItems.LoadMonItems();
  m_Countrys := TStringList.Create();
  m_Countrys.Text := LoadUTF('.\RoleCountry.txt');
//  SetCountrysExecuteId();
  LanguagePackage.GetLangText(99,803);
  if not ReadRoles() then
  begin
    DoMsgBox('���������ĵ�ʧ��!', '����', MB_ICONSTOP);
    Halt(0);
  end;
  Application.OnIdle  := ApplicationIdle;
  Panel1.DoubleBuffered  := True;
  SetLength(m_CopyedIdArray,0);

  //��ȡ�����ļ���Ϣ
  ReadConfigIni;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SetLength(m_ArrayMonsters,0);
  SetDocumentOpened( False );
  m_Xml := nil;
  m_SearchItemOfMonNameList.Free;
  InheritedList.Free;
  m_SearchMonList.Free;
  m_SearchMapList.Free;
  m_Countrys.Free;
  m_BackList.Free;
  m_FrtList.Free;
  m_DBItems.Free;
  m_DBMonsters.Free;
  m_XMLSkills.Free;
  m_MonItems.Free;
  CleanEnvirInfo();
  m_MapList.Free;
  m_ALlNPCList.Free;
  m_ALlNPC.Free;
  LanguagePackage.Free;
  DocStateCheck.Free;
  SetLength(m_CopyedIdArray,0);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if bJustGO then
  begin
    btn1Click(nil);
    Close;
  end;
end;

function RunProgram(ProgramName,sParam:string):Cardinal;
var
  StartInfo:STARTUPINFO;
  ProcessInfo:PROCESS_INFORMATION;
begin
//ִ���ⲿ����,ʧ�ܷ���0,�ɹ����ؽ��̾��
  Result:=0;
  if ProgramName='' then exit;
  GetStartupInfo(StartInfo);
  StartInfo.dwFlags:=StartInfo.dwFlags or STARTF_FORCEONFEEDBACK;

  if not CreateProcess(PChar(ProgramName),PChar(' "'+sParam+'"'),nil,nil,false,0,
          nil,PChar(ExtractFilePath(ProgramName)),StartInfo,ProcessInfo) then  exit;
  Result:=ProcessInfo.hProcess;
end;

function IsProgram_Runing(hProcess:Cardinal):Boolean; 
var 
  ExitCode:Cardinal; 
begin 
  //�鿴�����Ƿ��������� 
  GetExitCodeProcess(hProcess,ExitCode); 
  Result := ExitCode=STILL_ACTIVE 
end; 

procedure TfrmMain.GenLuaCBPFile(sParam: string);
const
  RunProgramName = '..\l2cbp\%s\l2cbp.exe';
var
  ProgramHandle: Cardinal;
  StrFileName: string;
begin
  if sParam <> '' then sParam := '"' + sParam + '"';
  StrFileName := G_DataPath+'\'+Format(RunProgramName, [LanguagePackage.LanguageName,sParam]);

  if not FileExists(StrFileName) then
  begin
    Application.MessageBox(PChar('�����ļ�:' + StrFileName +
      '�Ƿ����;'),PChar(Application.Title),MB_ICONERROR);
    Exit;
  end;

  ProgramHandle := RunProgram(StrFileName,sParam);
  while IsProgram_Runing(ProgramHandle) do Application.ProcessMessages;
end;


function TfrmMain.GetCountrysName(const nIndex: Integer): String;
var
  nIdx: Integer;
begin
  if nIndex = 0 then
    begin
      Result := '�κ������';
      Exit;
    end;
  Result := '�޴˹���';
  nIdx  := m_Countrys.IndexOfObject(TObject(nIndex));
  if nIdx < 0 then
    Exit;
  Result := m_Countrys.Strings[nIdx];
end;

function TfrmMain.GetMonsterNameEx(const nIndex: Integer): WideString;
begin
  if nIndex > High(m_ArrayMonsters) then
  begin
    Result := '';
  end
  else begin
    Result := m_ArrayMonsters[nIndex];
  end;
end;

function TfrmMain.GetItemName(const nIndex: Integer): String;
var
  nIdx: Integer;
begin
  if nIndex = 0 then
    begin
      Result := '';
      Exit;
    end;
  Result := '�޴���Ʒ';
  nIdx  := m_DBItems.IndexOfObject(TObject(nIndex));
  if nIdx < 0 then
    Exit;
  Result := m_DBItems.Strings[nIdx];
end;

function TfrmMain.GetJobName(iJob: Integer): string;
begin
  Result := '';
  if (iJob >= Integer(Low(TRoleJob))) and (iJob <= Integer(High(TRoleJob))) then
  begin
    Result := RoleJobStr[TRoleJob(iJob)];
  end; 
end;

function TfrmMain.GetMapNPC(const sMapName, sNPCName: string): TEnvirNPC;
var
  pMap: TRoleEnvir; 
begin
  Result := nil;
  pMap := GetMap( sMapName );
  if pMap = nil then
    Exit;

  Result := pMap.GetNPC(sNPCName);
end;

function TfrmMain.GetMap(const sMapName: string): TRoleEnvir;
var
  nIdx: Integer;
begin
  nIdx := m_MapList.IndexOf(sMapName);
  if nIdx > -1 then
    Result := TRoleEnvir(m_MapList.Objects[nIdx])
  else Result := nil;
end;

procedure TfrmMain.GetMagicSkills;
const
  DocumentFile = './Increase/Magic/magic.xml';
var
  I,LangID: Integer;
  t_Xml       : IXMLDOMDocument;
  t_NodeList  : IXMLDOMNodeList;
begin
  t_Xml := CoDOMDocument.Create();
  try
    if FileExists(DocumentFile) then
    begin
      t_Xml.load(DocumentFile);
      t_NodeList := t_Xml.selectNodes('//Magic');
      if t_NodeList <> nil then
      begin
        SetLength(m_Skills,t_NodeList.length);
        for I := 0 to t_NodeList.length - 1 do
        begin
          m_Skills[I].nId := StrToInt(t_NodeList.item[I].attributes.getNamedItem('ID').text);
          LangID := StrToInt(t_NodeList.item[I].childNodes[0].text);
          m_Skills[I].sName := LanguagePackage.GetLangText(MagicCategoryId,LangID);
          m_XMLSkills.AddObject(m_Skills[I].sName,TObject(m_Skills[I].nId));
        end;
      end;
    end;
  finally
    t_Xml := nil;
  end;
end;

function TfrmMain.GetMap(const nMapId: Integer): TRoleEnvir;
var
  I: Integer;
begin      
  Result := nil;
  for I := 0 to m_MapList.Count - 1 do
  begin
    if TRoleEnvir(m_MapList.Objects[I]).MapId = nMapId then
    begin
      Result := TRoleEnvir(m_MapList.Objects[I]);
      break;
    end;
  end;
end;

function TfrmMain.GetMapByLangid(const Langid: Integer): TRoleEnvir;
var
  I: Integer;
begin      
  Result := nil;
  for I := 0 to m_MapList.Count - 1 do
  begin
    if TRoleEnvir(m_MapList.Objects[I]).MapLangid = Langid then
    begin
      Result := TRoleEnvir(m_MapList.Objects[I]);
      break;
    end;
  end;
end;

function TfrmMain.GetMapMonster(const sMapID: Integer;
  sMonName: string): TEnvirMonster;
var
  Map: TRoleEnvir;
begin
  Result := nil;
  Map := GetMap( sMapID );
  if Map = nil then
    Exit;
  Result := Map.GetMonster(sMonName);
end;

function TfrmMain.GetMapMonster(const sMapName, sMonName: string): TEnvirMonster;
var
  Map: TRoleEnvir;
begin
  Result := nil;
  Map := GetMap( sMapName );
  if Map = nil then
    Exit;

  Result := Map.GetMonster(sMonName);
end;

function  TfrmMain.GetMapNPCByLandid(const Langid: Integer; const sNPCName: string):TEnvirNPC;
var
  Map: TRoleEnvir;
begin
  Result := nil;
  Map := GetMapByLangid( Langid );
  if Map = nil then
    Exit;

  Result := Map.GetNPC(sNPCName);
end;

function TfrmMain.GetMapNPC(const nMapId: Integer; const sNPCName: string): TEnvirNPC;
var
  Map: TRoleEnvir;
begin
  Result := nil;
  Map := GetMap( nMapId );
  if Map = nil then Exit;

  Result := Map.GetNPC(sNPCName);
end;

function TfrmMain.GetMapNPCOrMonster(const nMapId: Integer; const langid: Integer): tobject;
var
  Map: TRoleEnvir;
begin
  Result := nil;
  Map := GetMap( nMapId );
  if Map = nil then Exit;

  Result := Map.Getobject(langid);
end;


function  TfrmMain.GetMonLangid(const MonID: Integer):Integer;
var
  I: Integer;
begin
  if MonID <= 0 then
  begin
    Result := 0;
    Exit;
  end;

  for I := 0 to m_DBMonsters.Count - 1 do
  begin
     if TEnvirMonster(m_DBMonsters.Objects[i]).MonsterId = MonID then
     begin
       Result := TEnvirMonster(m_DBMonsters.Objects[i]).MonLangid;
     end;
  end;
end;


function TfrmMain.GetMonsterID(const MonsterName: string): Integer;
begin
  Result := TEnvirMonster(m_DBMonsters.Objects[m_DBMonsters.IndexOf(MonsterName)]).MonsterId;;
end;

function TfrmMain.GetMonsterLocations(const sMonName: string; MapList: TList; MonList: TList): Integer;
var
  I: Integer;
  AMap: TRoleEnvir;
  AMon: TEnvirMonster;
begin
  Result := 0;
  for I := 0 to m_MapList.Count - 1 do
  begin
    AMap := TRoleEnvir(m_MapList.Objects[I]);
    AMon := AMap.GetMonster(sMonName);
    if AMon <> nil then
    begin
      MapList.Add(AMap);
      MonList.Add(AMon);
      Inc(Result);
    end;
  end;
end;

function TfrmMain.GetMonsterName(const MonID: Integer): WideString;
var
  I: Integer;
begin
  Result := '�޴˹���';
  if MonID <= 0 then
  begin
    Result := '';
    Exit;
  end;

  for I := 0 to m_DBMonsters.count - 1 do
  begin
     if TEnvirMonster(m_DBMonsters.Objects[i]).MonsterId = MonID then
     begin
       Result := TEnvirMonster(m_DBMonsters.Objects[i]).Name;
     end;
  end;
end;

function TfrmMain.GetNPCScript(const sMapName, sNpcName: string): string;
var
  NPC: TEnvirNPC;
begin
  Result := '';           
  if sMapName = SYS_RESEVED_MAP then
    Exit;
  NPC := Self.GetMapNPC(sMapName, sNPCName);
  if (NPC = nil) or (NPC.Script = '') then Exit;
  Result := ExtRactFilePath(ParamStr(0)) + '\Envir\Market_def\' + NPC.Script + '.txt'; 
end;

function TfrmMain.GetNPCLangID(sNpcName: string): Integer;
begin
  Result := m_ALlNPCList.IndexOf(sNpcName);
  if Result <> -1 then
  begin
    Result := Integer(m_ALlNPCList.Objects[Result]);
  end;
end;

function TfrmMain.GetNPCLangName(iLangID: Integer): WideString;
begin
  Result := LanguagePackage.GetLangText(EnvirLangCategoryId, iLangID);
end;

function TfrmMain.GetNPCMonData(strText: string; strList: TStrings): Boolean;
var
  iSPos,iEPos: Integer;
  strTmp,strName: string;
begin
  strTmp := strText;
  strList.Clear;
  while Pos('<',strTmp) > 0 do
  begin
    iSPos := Pos('<',strTmp);
    iEPos := Pos('>',strTmp);
    if (iSPos > 0) and (iEPos > 0) then
    begin
      strName := Copy(strTmp,iSPos,iEPos-iSPos+1);
      Delete(strTmp,1,iEPos);
      if Pos('/M', strName) > 0 then
      begin
        strList.Add(strName);
      end;
    end;
  end;
  Result := strList.Count > 0;
end;

function TfrmMain.GetNPCName(iLangID: Integer): string;
var
  Idx: Integer;
begin
  Result := '';
  Idx := m_ALlNPCList.IndexOfObject(TObject(iLangID));
  if Idx <> -1 then
  begin
    Result := m_ALlNPCList.Strings[Idx];
  end;
end;

function TfrmMain.GetNPCScript(const nMapId: Integer; const sNpcName: string): string;
var
  NPC: TEnvirNPC;
begin
  Result := '';
  if nMapId = 0 then
    Exit;

  NPC := GetMapNPC( nMapId, sNpcName );
  if (NPC = nil) or (NPC.Script = '') then Exit;    
  Result := ExtRactFilePath(ParamStr(0)) + '\Envir\Market_def\' + NPC.Script + '.txt'; 
end;


function TfrmMain.GetRoleClass(const Tree: TTreeNode): IXMLDOMNode;
var
  sQueryText: string;
  Parent  : TTreeNode;
begin
  if Tree = TreeView1.Items[0] then
    begin
      Result := m_MainNode;
      Exit;
    end;
  sQueryText  := RoleClassSecName + '[@' + RoleClassNameAtbName + '=''' + IntToStr(Integer(Tree.Data)) + ''']';
  Parent  := Tree.Parent;
  while (Parent <> nil) and (Parent <> TreeView1.Items[0]) do
    begin
      sQueryText  := RoleClassSecName
                      + '[@' + RoleClassNameAtbName + '=''' + IntToStr(Integer(Parent.Data)) + ''']'
                      + '/' + sQueryText;
      Parent := Parent.Parent;
    end;
  Result := m_MainNode.selectSingleNode(sQueryText);
end;



function TfrmMain.GetRoleNeedDetail(btExecMode: TRoleExecuteMode;
  nExecId: Integer; out NeedMap: TRoleEnvir; out NeedMon: TEnvirMonster): Boolean;
var
  sMonName: string;
  RoleMap: TRoleEnvir;
  MapMon: TEnvirMonster;
  I, nMonOfItem, nCount: Integer;
begin
  m_SearchMapList.Clear;
  m_SearchMonList.Clear;
  m_SearchItemOfMonNameList.Clear;

  RoleMap := nil;
  MapMon := nil;
  
  case btExecMode of
    reNone: ;
    reGetItem,
    reBuyItem,
    reTakeOn,
    reJoinGuild,
    reStrengthenItem,
    reBuyCommissionItem:
    begin
      nMonOfItem := m_MonItems.GetMonsterListByItemId(nExecId, m_SearchItemOfMonNameList);
      nCount := 0;
      for I := 0 to nMonOfItem - 1 do
      begin
        Inc(nCount, GetMonsterLocations( m_SearchItemOfMonNameList[I], m_SearchMapList, m_SearchMonList ) );
      end;
      if nCount > 1 then
      begin
        TfrmSelLocation.SelectLocation(m_SearchMapList, m_SearchMonList, RoleMap, MapMon);
      end
      else if nCount > 0 then
      begin
        RoleMap := m_SearchMapList[0];
        MapMon := m_SearchMonList[0];
      end;
    end;
    reKillMon,reTameMon: begin
      sMonName := GetMonsterName(nExecId);
      nCount := GetMonsterLocations( sMonName, m_SearchMapList, m_SearchMonList );
      if nCount > 1 then
      begin       
        TfrmSelLocation.SelectLocation(m_SearchMapList, m_SearchMonList, RoleMap, MapMon);
      end
      else if nCount > 0 then
      begin
        RoleMap := m_SearchMapList[0];
        MapMon := m_SearchMonList[0];
      end;
    end;
    reCustom: ;
  end;                                     
  NeedMap := RoleMap;
  NeedMon := MapMon;
  Result := (RoleMap <> nil) and (MapMon <> nil);
end;

function TfrmMain.GetRoleNeedLocationStr(btExecMode: TRoleExecuteMode;
  nExecId: Integer): string;
var
  RoleMap: TRoleEnvir;
  MapMon: TEnvirMonster;
begin
  if GetRoleNeedDetail(btExecMode, nExecId, RoleMap, MapMon) then
  begin
    Result := Format('%s:%d:%d:%s', [RoleMap.m_sMapName, MapMon.Position.X,
      MapMon.Position.Y, MapMon.m_sName]);
  end
  else Result := '';
end;

function TfrmMain.GetRoleNodeById(const RoleId: Integer): IXMLDOMNode;
Resourcestring
  sQueryText  = '//' + RoleSecName + '[@'+ RoleIdAtbName + '=''%d'']';
begin
  Result := m_MainNode.selectSingleNode(Format(sQueryText, [RoleId]));
end;

function TfrmMain.GetSkillName(const nIndex: Integer): String;
var
  nIdx: Integer;
begin
  if nIndex = 0 then
    begin
      Result := '';
      Exit;
    end;
  Result := '�޴˼���';
  nIdx  := m_XMLSkills.IndexOfObject(TObject(nIndex));
  if nIdx < 0 then
    Exit;
  Result := m_XMLSkills.Strings[nIdx];
end;

function TfrmMain.GetTreeNodeFromListView(const Item: TListItem): TTreeNode;
var
  I: Integer;
begin
  Result := nil;
  if (m_CurTreeNode = nil) or (Item = nil) then
    Exit;
  for I := 0 to m_CurTreeNode.Count - 1 do
    begin
    if (CompareText(m_CurTreeNode.Item[I].Text, Item.Caption) = 0) then
      begin
        Result := m_CurTreeNode.Item[I];
        break;
      end;
    end;
end;

procedure TfrmMain.GotoRoleClass(const Tree: TTreeNode);
begin
  if Tree = nil then
    Exit;
  if (frmViewRoleInfo <> nil) and frmViewRoleInfo.Showing then
    frmViewRoleInfo.Close
  else
    if (Tree = m_CurTreeNode)  then
      Exit;
  AddToBack(m_CurTreeNode);
  m_CurTreeNode := Tree;
  m_CurTreeNode.Selected  := True;
  RefCurrentRoleClass();
end;

procedure TfrmMain.I2Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  ListView1.ViewStyle := TViewStyle(TMenu(Sender).Tag);
end;

function TfrmMain.IsDocumentOpened: Boolean;
begin
  Result := not DocStateCheck.CheckDocState(DocStateName);
end;

procedure TfrmMain.ListView1DblClick(Sender: TObject);
begin
  O1Click(O1);
end;

procedure TfrmMain.ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: Integer;
  Item, TargetItem: TListItem;
  Tree, TargetTree: TTreeNode;
  Node, TargetNode, NewNode: IXMLDOMNode;
begin
  TargetItem  := ListView1.GetItemAt(X, Y);
  TargetTree  := GetTreeNodeFromListView(TargetItem);
  if TargetTree = nil then
    Exit;
  TargetNode  := GetRoleClass(TargetTree);
  if TargetNode = nil then
    Exit;
  if (Source is TListView) then
    begin
      for I := 0 to ListView1.Items.Count - 1 do
        begin
          Item  := ListView1.Items[I];
          if not Item.Selected then
            continue;
          case Integer(Item.SubItems.Objects[0]) of
            0:begin
              Tree  := GetTreeNodeFromListView(Item);
              if Tree = nil then
                break;
              if FindChildNode(TargetTree, Item.Caption, 0) <> nil then
                begin
                  DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s �ķ���!�ƶ�ʧ��!', [Item.Caption]), '����', MB_ICONSTOP);
                  break;
                end;
              Node  := GetRoleClass(Tree);
              if Node = nil then
                break;
              NewNode := Node.cloneNode(WordBool(-1));
              if NewNode = nil then
                break;
              if Node.parentNode <> nil then
                Node.parentNode.removeChild(Node);
              if TargetNode.appendChild(NewNode) = nil then
                break;
              Tree.MoveTo(TargetTree, naAddChild);
            end;
            else begin
{$IF SHOWROLESINTREE}
              Tree  := GetTreeNodeFromListView(Item);
              if Tree = nil then
                break;
{$IFEND}
              if FindRoleInClass(TargetNode, Item.Caption) <> nil then
                begin
                  DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s ������!�ƶ�ʧ��!', [Item.Caption]), '����', MB_ICONSTOP);
                  break;
                end;
              Node  := GetRoleNodeById(Integer(Item.SubItems.Objects[1]));
              if Node = nil then
                break;
              NewNode := Node.cloneNode(WordBool(-1));
              if NewNode = nil then
                break;
              if Node.parentNode <> nil then
                Node.parentNode.removeChild(Node);
              if TargetNode.appendChild(NewNode) = nil then
                break;
{$IF SHOWROLESINTREE}
              Tree.MoveTo(TargetTree, naAddChild)
{$IFEND}
            end;
          end;
        end;
    end;
  if (Source is TTreeView) then
    begin
      Tree  := TTreeView(Source).Selected;
      case Integer(Tree.Data) of
        0:begin
          if FindChildNode(TargetTree, Tree.Text, 0) <> nil then
            begin
              DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s �ķ���!�ƶ�ʧ��!', [Tree.Text]), '����', MB_ICONSTOP);
              Exit;
            end;
          Node  := GetRoleClass(Tree);
          if Node = nil then
            Exit;
          NewNode := Node.cloneNode(WordBool(-1));
          if NewNode = nil then
            Exit;
          if Node.parentNode <> nil then
            Node.parentNode.removeChild(Node);
          if TargetNode.appendChild(NewNode) = nil then
            Exit;
          Tree.MoveTo(TargetTree, naAddChild);
        end;
{$IF SHOWROLESINTREE}
        else begin
          if FindRoleInClass(TargetNode, Tree.Text) <> nil then
            begin
              DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s �ķ���!�ƶ�����!', [Tree.Text]), '����', MB_ICONSTOP);
              Exit;
            end;
          Node  := GetRoleNodeById(Integer(Tree.Data));
          if Node = nil then
            Exit;
          NewNode := Node.cloneNode(WordBool(-1));
          if NewNode = nil then
            Exit;
          if Node.parentNode <> nil then
            Node.parentNode.removeChild(Node);
          if TargetNode.appendChild(NewNode) = nil then
            Exit;
          Tree.MoveTo(TargetTree, naAddChild);
        end;
{$IFEND} 
      end;
    end;

  SaveRoleFile();
  RefCurrentRoleClass();
end;

procedure TfrmMain.ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Item: TListItem;
  function TreeViewCanAccept():Boolean;
  var
    P: TTreeNode;
  begin
    Result := False;
    if m_CurTreeNode = nil then
      Exit;
    Result := TTreeView(Source).Selected <> m_CurTreeNode;
    if not Result then
      Exit;
    P  := m_CurTreeNode.Parent;
    while P <> nil do
      if TTreeView(Source).Selected = P then
        begin
          Result := False;
          break;
        end
        else P := P.Parent;
  end;
begin
  Item    := ListView1.GetItemAt(X, Y);
  Accept  := False;
  if (Source is TListView) then
    Accept := (Item <> nil) and not Item.Selected and (Integer(Item.SubItems.Objects[0]) = 0);
  if (Source is TTreeView) then
    Accept  :=  TreeViewCanAccept();
end;

procedure TfrmMain.ListView1Edited(Sender: TObject; Item: TListItem;
  var S: string);
var
  Node  : IXMLDOMNode;
  Tree  : TTreeNode;
begin
  S := TrimRight(S);
  case Integer(Item.SubItems.Objects[0]) of
    0:begin
      Tree  := GetTreeNodeFromListView(Item);
      if Tree = nil then
        begin
          S := Item.Caption;
          Exit;
        end;
      Node := GetRoleClass(Tree);
      if Node = nil then
        begin
          S := Item.Caption;
          Exit;
        end;
      if FindChildNode(Tree.Parent, S, 0) <> nil then
        begin
          DoMsgBox('�Ѿ�����ͬ�����࣡', '����', MB_ICONSTOP);
          S := Item.Caption;
          Exit;
        end;
      Tree.Text := S;
      LanguagePackage.ReplaceLangText(RoleLangCategoryId, (Node as IXMLDOMElement).getAttribute(RoleClassNameAtbName),S);
      SaveRoleFile();
    end;
    1:begin
      Node  := GetRoleNodeById(Integer(Item.SubItems.Objects[1]));
      if Node = nil then
        Exit;
      if HasRoleNameInCurClass(S) then
        begin
          DoMsgBox('�Ѿ�����ͬ������', '����', MB_ICONSTOP);
          S := Item.Caption;
          Exit;
        end;
      LanguagePackage.ReplaceLangText(RoleLangCategoryId, (Node as IXMLDOMElement).getAttribute(RoleNameAtbName),S);
      SaveRoleFile();
{$IF SHOWROLESINTREE}
      Tree  := GetTreeNodeFromListView(Item);
      if (Tree <> nil) and (Tree.Data = Pointer(Item.SubItems.Objects[1])) then
        Tree.Text := S;  
{$IFEND}
    end;
  end;
end;

procedure TfrmMain.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_BACK:
      if not ListView1.IsEditing then
        ToolButton1Click(ToolButton1);
    VK_F2     : R1Click(R1);
    VK_DELETE : D1Click(D1);
    VK_RETURN : O1Click(O1);
    Byte('c') - $20 : if Shift = [ssCtrl] then N4Click(N4);
    Byte('v') - $20 : if Shift = [ssCtrl] then P1Click(P1);
  end;
end;

procedure TfrmMain.ListViewSearchResultDblClick(Sender: TObject);
begin
  if ListViewSearchResult.Selected = nil then
    Exit;
  EditRole( Integer(ListViewSearchResult.Selected.Data),ListViewSearchResult );
end;

function TfrmMain.LoadDBItems: Integer;
var
  Doc: IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;
  I: Integer;
  Element: IXMLDOMElement;
begin
  m_DBItems.Clear;
  Result := 0;

  Doc := CoDOMDocument.Create();
  Doc.load(Format(sItemFile, [G_DataPath]));

  if Doc.parseError.errorCode <> 0 then
    Raise Exception.CreateFmt('��ȡ��Ʒ��������ʧ�ܣ�#13#10%s', [Doc.parseError.reason]);

  Nodes := Doc.documentElement.selectNodes('StdItem');
  for I := 0 to Nodes.Length - 1 do
  begin
    Element := Nodes.item[I] as IXMLDOMElement;
    m_DBItems.AddObject(
      LanguagePackage.GetLangText(ItemLangCategoryId, Element.getAttribute('name')),
      TObject(Integer(Element.getAttribute('id'))));
    Inc(Result);
  end;
end;

function TfrmMain.LoadDBMonsters: Integer;
var
  Doc: IXMLDOMDocument;
  Nodes: IXMLDOMNodeList;
  I: Integer;
  Element: IXMLDOMElement;
  EMonster: TEnvirMonster;
begin
  m_DBMonsters.Clear;
  Result := 0;

  Doc := CoDOMDocument.Create();
  Doc.load(Format(sMonsterFile, [G_DataPath]));
  if Doc.parseError.errorCode <> 0 then
    Raise Exception.CreateFmt('��ȡ������������ʧ�ܣ�#13#10%s', [Doc.parseError.reason]);

  Nodes := Doc.documentElement.selectNodes('Mon');
  SetLength(m_ArrayMonsters,Nodes.Length);
  for I := 0 to Nodes.Length - 1 do
  begin
    Element := Nodes.item[I] as IXMLDOMElement;
    EMonster := TEnvirMonster.Create;
    EMonster.MonsterId := Element.getAttribute('entityid');
    EMonster.MonLangid := Element.getAttribute('name');
    EMonster.m_sName := LanguagePackage.GetLangText(MonLangCategoryId, Element.getAttribute('name'));
    m_ArrayMonsters[I] := EMonster.Name;
    m_DBMonsters.AddObject(m_ArrayMonsters[I], EMonster);
    Inc(Result);
  end;
end;

function TfrmMain.LoadEnvirInfo: Integer;
var
  xml: IXMLDOMDocument;
  MapList, NodeList: IXMLDOMNodeList;
  Element: IXMLDOMElement;
  I, J, x1, x2, y1 ,y2: Integer;
  RoleMap: TRoleEnvir;
  MissionNPC: TEnvirNPC;
  MissionMon: TEnvirMonster;
  function GetCenter(n1, n2 :Integer):Integer;
  begin
   Result := 0;
   Result := (n1 + n2) div 2;
  end;
begin
  CleanEnvirInfo();


  xml := CoDOMDocument.Create;
  xml.load(Format(sEnviromentFile, [G_DataPath]));
  if xml.parseError.errorCode <> 0 then
//    Raise Exception.Create( xml.parseError.reason );
    Raise Exception.Create( '������Ϣ�ļ��д� ����µ����°汾����' );
  MapList  := xml.documentElement.selectNodes('//scence');///Merchants/MerChant[@Kind=''0'']');

  for I := 0 to MapList.length - 1 do
  begin
    RoleMap := TRoleEnvir.Create;
    RoleMap.M_MapNameLangid := MapList.item[I].attributes.getNamedItem('scencename').nodeValue;
    RoleMap.m_sMapName := LanguagePackage.GetLangText(EnvirLangCategoryId, RoleMap.M_MapNameLangid);
    RoleMap.m_nMapId := MapList.item[I].attributes.getNamedItem('scenceid').nodeValue;
    m_MapList.AddObject( RoleMap.m_sMapName, RoleMap );

    NodeList := MapList.item[I].selectNodes('npcs/npc');
    for J := 0 to NodeList.length - 1 do
    begin
      MissionNPC := TEnvirNPC.Create;
      Element := NodeList.item[J] as IXMLDOMElement;
      MissionNPC.NPCLangID := Element.getAttribute('name');
      MissionNPC.m_sName    := LanguagePackage.GetLangText(EnvirLangCategoryId, MissionNPC.NPCLangID);
      MissionNPC.m_sScript := Element.getAttribute('script');
      MissionNPC.m_Position.X := Element.getAttribute('posx');
      MissionNPC.m_Position.Y := Element.getAttribute('posy');
      RoleMap.NPCList.AddObject( MissionNPC.m_sName, MissionNPC );
      m_ALlNPCList.AddObject(MissionNPC.m_sName,TObject(MissionNPC.NPCLangID));
      m_ALlNPC.AddObject(MissionNPC.m_sName,TObject(MissionNPC.NPCLangID))
    end;

    NodeList := MapList.item[I].selectNodes('refreshs/refresh');
    for J := 0 to NodeList.length - 1 do
    begin
      MissionMon:= TEnvirMonster.Create;
      Element := NodeList.item[J] as IXMLDOMElement;
      MissionMon.MonsterId := Element.getAttribute('entityid');
      MissionMon.m_sName    := GetMonsterName(MissionMon.MonsterId);
      MissionMon.MonLangid    := GetMonLangid(MissionMon.MonsterId);
      x1 := Element.getAttribute('mapx1');
      y1 := Element.getAttribute('mapy1');
      x2 := Element.getAttribute('mapx2');
      y2 := Element.getAttribute('mapy2');
      MissionMon.m_Position.X :=  GetCenter(x1, x2);
      MissionMon.m_Position.Y :=  GetCenter(y1, y2);
      RoleMap.MonList.AddObject( MissionMon.m_sName, MissionMon );
    end;
  end;
  xml := nil;
  Result := m_MapList.Count;
end;

function TfrmMain.LoadRoles: Boolean;
var
  node: IXMLDOMNode;
begin
  Result := False;
  if not FileExists(DocumentName) then
  begin
    if not MXML.CreateXml(DocumentName, '521g �����ļ�', RoleMainSecName) then
    begin
      Exit;
    end
    else begin
      m_Xml.load(DocumentName);
      node := m_Xml.documentElement;
      with node.appendChild(m_Xml.createElement(RoleStatSecName)) as IXMLDOMElement do
      begin
        setAttribute(StatNewRoleId,1);
        setAttribute(StatAttrOfOpenFlag,0);
      end;
      with node.appendChild(m_Xml.createElement(RoleVersion)) as IXMLDOMElement do
      begin
        setAttribute(RoleVersionAttribute,CURRENTROLE_VERSION);
      end;
      node.appendChild(m_Xml.createElement(RoleRecycleResScName));
      m_Xml.save(DocumentName);
    end;
  end;
  m_Xml.load(DocumentName);
  if m_Xml.parseError.errorCode <> 0 then
  begin
    ShowMessage(m_Xml.parseError.reason);
    Exit;
  end;
  IsReadOnly := False;
  if IsDocumentOpened() then
  begin
    if Application.MessageBox(PChar(Format('��ʾ�ĵ��ѱ�(%s)��ռ�޸ģ��Ƿ���ֻ��ģʽ�����ĵ���',[DocStateCheck.OpenDocIP])),PChar(Application.Title),MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IDYES then
    begin
      IsReadOnly := True;
      N1.Visible := False;
      D1.Visible := False;
      ToolButton16.PopupMenu := nil;
      R1.Visible := False;
      P1.Visible := False;
    end
    else begin
      ExitProcess(DWord(-2));
    end;
  end;
  Result := True;
end;

procedure TfrmMain.N4Click(Sender: TObject);
var
  I,iCount: Integer;
begin
  iCount := 0;
  SetLength(m_CopyedIdArray,ListView1.SelCount);
  for I := 0 to ListView1.Items.Count - 1 do
  begin
    if ListView1.Items[I].Selected then
    begin
      if ListView1.Items[I].SubItems.Objects[0] <> nil then
      begin
        m_CopyedIdArray[iCount] := Integer(ListView1.Items[I].SubItems.Objects[1]);
        Inc(iCount);
      end;
    end;
  end;
end;

procedure TfrmMain.N6Click(Sender: TObject);
var
 I, iEntrust, imultiAward, itype : Integer;
 NodeList: IXMLDOMNodeList;
 RoleEle, MutiTableEle , TempEle: IXMLDOMElement;
 sid:string;
begin
  if Application.MessageBox(
    PChar('�˲������ɳ������Ƿ������'),  '��ʾ', MB_ICONQUESTION or MB_YESNO) <> ID_YES then
    Exit;
  NodeList := m_MainNode.selectNodes('//' + RoleSecName + '[@multiAward=2]');
  for I := 0 to NodeList.length -1 do
  begin
   RoleEle := NodeList[i] as IXMLDOMElement;
   sid :=  sid + RoleEle.getAttribute(RoleIdAtbName) + ';';
   if i mod 10 =0 then  sid := sid + #13#10;

   MutiTableEle := RoleEle.selectSingleNode(MultiAwardTable) as IXMLDOMElement;
   if MutiTableEle = nil  then Continue;
   with MutiTableEle do
   begin
    TempEle := m_Xml.createElement(MultiAwardSTable);
    TempEle.setAttribute(MAMoneyTypeAttr, RoleEle.getAttribute(DoubleMoneyTypeAttr));
    TempEle.setAttribute(MARateAttr, RoleEle.getAttribute(multiAwardAttr));
    TempEle.setAttribute(MAmoneyCountAttr, RoleEle.getAttribute(entrustAttr));
    appendChild(TempEle);

    TempEle := m_Xml.createElement(MultiAwardSTable);
    TempEle.setAttribute(MAMoneyTypeAttr, 3);
    TempEle.setAttribute(MARateAttr, 3);
    TempEle.setAttribute(MAmoneyCountAttr, 3);
    appendChild(TempEle);
   end;
   //����Ϊ4 �����´��ٸ���
   RoleEle.setAttribute(multiAwardAttr, 4)
  end;
  SaveRoleFile();
  showmessage('������� �������񱻸��£�' + sid);
end;


procedure TfrmMain.N7Click(Sender: TObject);
begin
  BatchUpdateAword;
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
  BatchUpdateRoleDescribe(True);
end;

procedure TfrmMain.N9Click(Sender: TObject);
var
  Nodes, ItemNodes: IXMLDOMNodeList;
  I, J, nCompleteCount,iMode: Integer;
  Element, ItemElement: IXMLDOMElement;
  sLocation: string;
  MissingList: TStrings;
begin
  if (m_CurTreeNode = nil) or (m_CurTreeNode.Data <> nil) then
    Exit;
    
  if Application.MessageBox(
    PChar('�˲��������¡�' + m_CurTreeNode.Text + '���Լ��������ӷ�������������������Ϊ���ռ���Ʒ���Լ�����ɱ��������������Ŀ�ĵ����ݣ��Ƿ������'),
    '��ʾ', MB_ICONQUESTION or MB_YESNO) <> ID_YES then
  begin
    Exit;
  end;

  nCompleteCount := 0;
  MissingList := TStringList.Create;
  try
    //������������λ��
    Nodes := GetRoleClass(m_CurTreeNode).selectNodes('.//' + RoleSecName);
    for I := 0 to Nodes.length - 1 do
    begin
      Element := Nodes.item[i] as IXMLDOMElement;
      ItemNodes := Element.selectNodes(RoleItemsSceName + '/' +��RoleItemSecName + '[@' + ItemExecModeAtbName + '<=2]');
      for J := 0 to ItemNodes.length - 1 do
      begin
        ItemElement := ItemNodes.item[j] as IXMLDOMElement;
        iMode := ItemElement.getAttribute(ItemExecModeAtbName);
        sLocation := SetStrLocations(TRoleExecuteMode(iMode),GetRoleNeedLocationStr(TRoleExecuteMode(iMode),ItemElement.getAttribute(ItemExecIdAtbName)));
        if sLocation <> '' then
        begin
//          ItemElement.setAttribute(ItemNeedLocationAtbName, sLocation);
          Inc(nCompleteCount);
        end
        else begin
//          MissingList.Add(Element.getAttribute(RoleClassNameAtbName) + '('
//            + RoleExecuteModeStr[TRoleExecuteMode(ItemElement.getAttribute(ItemExecModeAtbName))] + '/'
//            + ItemElement.getAttribute(ItemExecIdAtbName) + ')');
        end;
      end;
    end;
    Application.MessageBox( PChar('�ɹ�������' + IntToStr(nCompleteCount) + '�����������λ����Ϣ��'),
        '��ʾ', MB_ICONINFORMATION);
    SaveRoleFile();
    //�����޷�ȷ�������������¼��Ϣ
    sLocation := ExtRactFilePath(ParamStr(0)) + '/UMCK-FAIL.txt';
    if MissingList.Count = 0 then
    begin
      DeleteFile(sLocation);
    end
    else begin
      MissingList.SaveToFile(sLocation);
      Application.MessageBox(
        PChar('����'+ IntToStr(MissingList.Count) + '�����������޷�����λ����Ϣ����Ϊ�޷��ҵ�ƥ�������'),
        '��ʾ', MB_ICONINFORMATION);
      EditTextFile(sLocation);
    end;
  finally
    MissingList.Free;
  end;
end;

procedure TfrmMain.NPC1Click(Sender: TObject);
begin
  BatchUpdateRoleDescribe(False);
end;

procedure TfrmMain.O1Click(Sender: TObject);
var
  Tree: TTreeNode;
begin
  if ListView1.Selected = nil then
    Exit;
  case Integer(ListView1.Selected.SubItems.Objects[0]) of
    0:begin
      Tree := GetTreeNodeFromListView(ListView1.Selected);
      if nil = Tree then
        Exit;
      TreeView1.Selected := Tree;
      GotoRoleClass(Tree);
    end;
    1:begin
      EditRole( Integer(ListView1.Selected.SubItems.Objects[1]),ListView1 );
    end;
  end;
end;

procedure TfrmMain.P1Click(Sender: TObject);
var
  nRoleID: Integer;
begin
  for nRoleID in m_CopyedIdArray do
  begin
    if nRoleID > 0 then
    begin
      CloneRole(nRoleID);
    end;
  end;
  SetLength(m_CopyedIdArray,0);
end;

procedure TfrmMain.PopupMenu2Popup(Sender: TObject);
begin
  O1.Enabled  := ListView1.SelCount = 1;
  R1.Enabled  := ListView1.SelCount = 1;
  D1.Enabled  := ListView1.SelCount > 0;
  N1.Enabled  := m_CurTreeNode    <> nil;
  N4.Enabled  := D1.Enabled and (ListView1.Selected.SubItems.Objects[0] <> nil);
  P1.Enabled  := High(m_CopyedIdArray) >= 0;
end;

procedure TfrmMain.PopupMenu3Popup(Sender: TObject);
begin
  N8.Enabled := NPC1.Enabled;
  N9.Enabled := (m_CurTreeNode <> nil) and (m_CurTreeNode.Data = nil);
end;

procedure TfrmMain.R1Click(Sender: TObject);
begin
  if (ListView1.Selected <> nil) and not ListView1.IsEditing then
    ListView1.Selected.EditCaption;
end;

function TfrmMain.HasRoleNameInCurClass(const s: string):Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to ListView1.Items.Count - 1 do
    if (Integer(ListView1.Items[I].SubItems.Objects[0]) = 1)
    and (CompareText(ListView1.Items[I].Caption, s) = 0) then
      begin
        Result := True;
        break;
      end;
end;

procedure TfrmMain.R2Click(Sender: TObject);
Resourcestring
  sNewNameBegin = '�½����� ';
var
  sName: string;
  Node : IXMLDOMNode;
  nRoleID: Integer;
  function GetNewName():string;
  var
    nIdx : Integer;
  begin
    nIdx  := 1;
    while true do
    begin
      Result := sNewNameBegin + IntToStr(nIdx);
      if not HasRoleNameInCurClass(Result) then
        break;
      Inc(nIdx);
    end;
  end;
begin
  nRoleId := AllocRoleId();
  if nRoleId = 0 then
    Exit;
  if GetRoleNodeById(nRoleId) <> nil then
    Raise Exception.Create('Alloc Role Id Failed!');
  sName := GetNewName();
  Node  := GetRoleClass(m_CurTreeNode);
  if nil = Node then
    Exit;
  if AddNewRole(Node, nRoleId, sName) = nil then
    Exit;
{$IF SHOWROLESINTREE}
      with TreeView1.Items.AddChild(m_CurTreeNode, sName) do
      begin
        ImageIndex    := 1;
        SelectedIndex := 1;
        Data          := Pointer(nRoleId);
      end; 
{$IFEND}
  with ListView1.Items.Add do
  begin
    Caption := sName;
    ImageIndex  := 1;
    SubItems.AddObject('����', TObject(1));
    SubItems.AddObject('', TObject(nRoleId));
    EditCaption;
  end;
end;

procedure TfrmMain.ReadConfigIni;
var
  StrFileName: string;
begin
  StrFileName := ExtRactFilePath(ParamStr(0)) + sConfigName;
  if FileExists(StrFileName) then
  begin
    with TIniFile.Create(ExtRactFilePath(ParamStr(0)) + sConfigName) do
    begin
      G_CbpPath := ReadString(sMainConfigKey, sCbpPath, '');
      Free;
    end;
  end;
end;

function TfrmMain.ReadRoles: Boolean;
begin
  Result := UpDateDocument() and RefreshRoleClass();
  //SaveRoleFile();
end;

procedure TfrmMain.ReadXmlNode(const Node: IXMLDOMNode; const Tree: TTreeNode);
var
  I       : Integer;
  Atb     : IXMLDOMNode;
  NewTree : TTreeNode;
begin
  if CompareText(Node.nodeName, RoleClassSecName) = 0 then
  begin
    Atb := Node.attributes.getNamedItem(RoleClassNameAtbName);
    if Atb = nil then
      Exit;
    NewTree := TreeView1.Items.AddChild(Tree, LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(Atb.text)));
    NewTree.ImageIndex    := 0;
    NewTree.SelectedIndex := 0;
    NewTree.Data          := Pointer(StrToInt(Atb.text));
    for I := 0 to Node.childNodes.length - 1 do
      ReadXmlNode(Node.childNodes.item[I], NewTree);
  end;
{$IF SHOWROLESINTREE}
  if CompareText(Node.nodeName, RoleSecName) = 0 then
  begin
    if (Node.attributes.getNamedItem(RoleIdAtbName) = nil)
    or (Node.attributes.getNamedItem(RoleNameAtbName) = nil) then
      Exit;
    NewTree := TreeView1.Items.AddChild(Tree, LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue));
    NewTree.ImageIndex    := 1;
    NewTree.SelectedIndex := 1;
    I := Node.attributes.getNamedItem(RoleIdAtbName).nodeValue;
    NewTree.Data          := Pointer(I);
  end;
{$IFEND}
end;

procedure TfrmMain.RefCurrentRoleClass;
var
  I, nRoleId: Integer;
  Node, ChildNode, Atb: IXMLDOMnode;
begin
  if frmViewRoleInfo <> nil then
    frmViewRoleInfo.Close;
  ListView1.Visible := True;
  if m_CurTreeNode = nil then
    Exit;
  ListView1.Clear;
  Node  := GetRoleClass(m_CurTreeNode);
  if (nil = Node) then
    if (m_CurTreeNode = TreeView1.Items[0]) then
      Node  := m_MainNode
    else Exit;
    
  for I := 0 to Node.childNodes.length - 1 do
    begin
      ChildNode := Node.childNodes.item[I];
      if CompareText(ChildNode.nodeName, RoleClassSecName) = 0 then
        begin
          Atb := ChildNode.attributes.getNamedItem(RoleClassNameAtbName);
          if Atb = nil then
            continue;
          with ListView1.Items.Add do
            begin
              Caption     := LanguagePackage.GetLangText(RoleLangCategoryId, StrToInt(Atb.text));
              ImageIndex  := 0;
              SubItems.AddObject('����', TObject(0));
              SubItems.AddObject('', nil);
            end;
          continue;
        end;
      if CompareText(ChildNode.nodeName, RoleSecName) = 0 then
        begin
          NPC1.Enabled := True;
          if (ChildNode.attributes.getNamedItem(RoleIdAtbName) = nil)
          or (ChildNode.attributes.getNamedItem(RoleNameAtbName) = nil) then
            continue;
          with ListView1.Items.Add do
            begin
              Caption     := LanguagePackage.GetLangText(RoleLangCategoryId, ChildNode.attributes.getNamedItem(RoleNameAtbName).nodeValue);
              ImageIndex  := 1;
              SubItems.AddObject('����', TObject(1));
              nRoleId := ChildNode.attributes.getNamedItem(RoleIdAtbName).nodeValue;
              SubItems.AddObject('', TObject(nRoleId));
            end;
        end; 
    end;
      
{      for I := 0 to m_CurTreeNode.Count - 1 do
        begin     
          Node  := GetNodeClass(m_CurTreeNode.Item[I]);
          if Node = nil then
            continue;    
          Item  := ListView1.Items.Add;
          Item.Caption := m_CurTreeNode.Item[I].Text;
          Item.ImageIndex  := -1;
          if CompareText(Node.nodeName,  RoleClassSecName) = 0 then
            begin    
              Item.ImageIndex  := 0;
              Item.SubItems.AddObject('����', TObject(0));
            end;
          if CompareText(Node.nodeName,  RoleSecName) = 0 then
            begin    
              Item.ImageIndex  := 1;
              Item.SubItems.AddObject('����', TObject(1));
            end;
        end;  }
end;

procedure TfrmMain.BatchUpdateAword;
Resourcestring
  sQueryText  = '//' + RoleAwardSecName + '[@'+ AwardModeAtbName + '=''%d'']';
var
  I,srcCount: Integer;
  NodeList: IXMLDOMNodeList;
  Element: IXMLDOMElement;
begin
  with TfrmBatchSetAward.Create(self) do
  begin
    if ShowModal = mrOK then
    begin
      NodeList := m_MainNode.selectNodes(Format(sQueryText, [Integer(ComboBox1.Items.Objects[ComboBox1.ItemIndex])]));
      for I := 0 to NodeList.length - 1 do
      begin
        Element := NodeList.item[I] as IXMLDOMElement;
        srcCount := Element.getAttribute(AWardCountAtbName);
        Element.setAttribute(AWardCountAtbName,Round(srcCount*StrToFloat(edtDouble.Text)));
      end;
      if NodeList.length > 0 then
      begin
        SaveRoleFile();
        ShowMessage('������'+IntToStr(NodeList.length)+'��');
      end;
    end;
    Free;
  end;
end;

procedure TfrmMain.BatchUpdateRoleDescribe(bOption: Boolean);
const
  sErrorText = '%s ---- %s ---- %s ----- ����������������(�п�����NPC���ƻ�������ƴ���)';
var
  I,J,iPos: Integer;
  TipName,RoleName,MapName,newName,sDesc,newDesc: string;
  m_Role,Node: IXMLDOMNode;
  strList,ErrorList: TStrings;
  function UpdateDescribe(strDescribe: string): string;
  var
    iP: Integer;
    strName,substr: string;
    tNPC: TEnvirNPC;
    tMon: TEnvirMonster;
  begin
    Result := '';
    iP := 1; substr := '';
    while PosEx(':',strDescribe,iP) > 0 do
      iP := PosEx(':',strDescribe,iP)+1;
    strName := Copy(strDescribe,iP,Length(strDescribe)-iP);
    tNPC := GetMapNPC(MapName,strName);
    tMon := GetMapMonster(MapName,strName);
    if bOption then
    begin
      iP := Pos('/M',strDescribe);
      if iP > 0 then
      begin
        if (tNPC <> nil) or (tMon <> nil) then
        begin
          substr := '('+Copy(strDescribe,iP+2,Pos(':',strDescribe)-iP-2)+')';
        end;
        Result := '<' + strName + substr + Copy(strDescribe,iP,Length(strDescribe)-iP+1);
      end
      else
        Result := strDescribe;
    end
    else
    begin
      if tNPC <> nil then
        substr := IntToStr(tNPC.Position.X) + ':' + IntToStr(tNPC.Position.Y);
      if substr <> '' then
      begin
        Result := Copy(strDescribe,1,Pos(':',strDescribe)) + substr + ':' + strName + '>';
      end;
      if tMon <> nil then Result := strDescribe;
    end;
  end;
begin
  if TreeView1.Selected = nil then Exit;
  if bOption then
    TipName := '������������?'
  else
    TipName := '������������NPC����?';
  if Application.MessageBox(PChar(TipName), '�Ƿ�ȷ��', MB_YESNO) <> ID_YES then Exit;
  strList := TStringList.Create;
  ErrorList := TStringList.Create;
  Panel1.Enabled := False;
  Panel3.Enabled := False;
  try
    for I := 0 to ListView1.Items.Count - 1 do
    begin
      m_Role  := GetRoleNodeById(Integer(ListView1.Items[I].SubItems.Objects[1]));
      if m_Role = nil then continue;
      RoleName := LanguagePackage.GetLangText(RoleLangCategoryId, m_Role.attributes.getNamedItem(RoleNameAtbName).nodeValue);
      Node  := m_Role.selectSingleNode(RoleDescSecName);
      if (Node = nil) or (Node.text = '') then continue;
      sDesc := LanguagePackage.GetLangText(RoleLangCategoryId,StrToInt(Node.text));
      if GetNPCMonData(sDesc,strList) then
      begin
        newDesc := sDesc;
        for J := 0 to strList.Count - 1 do
        begin
          iPos := Pos('/M',strList.Strings[J]);
          MapName := Copy(strList.Strings[J],iPos+2,Pos(':',strList.Strings[J])-iPos-2);
          newName := UpdateDescribe(strList.Strings[J]);
          if newName <> '' then
            newDesc := StringReplace(newDesc,strList.Strings[J],newName,[rfReplaceAll])
          else
            ErrorList.Add(format(sErrorText,[RoleName,MapName,strList.Strings[J]]))
        end;
        if newDesc <> sDesc then
        begin
          LanguagePackage.ReplaceLangText(RoleLangCategoryId,StrToInt(Node.text),newDesc);
        end;
      end;
    end;
    if ErrorList.Count > 0 then
    begin
      ErrorList.SaveToFile('.\ErrorReSetPos.txt');
      EditTextFile('.\ErrorReSetPos.txt');
    end;
  finally
    ErrorList.Free;
    strList.Free;
    Panel1.Enabled := True;
    Panel3.Enabled := True;
  end;
  if bOption then
    TipName := '���������������'
  else
    TipName := '������������NPC�������';
  ShowMessage(TipName);
end;

function TfrmMain.GetXMLNode(Node: IXMLDOMNode): string;
begin
  if  (Node.nodeName = PassAttr)
   or (Node.nodeName = RoleItemSecName)
   or (Node.nodeName = RoleAwardSecName)
   or (Node.nodeName = RoleCondition)
   or (Node.nodeName = RoleSecName)
   or (Node.nodeName = AwardTagAttr)
   or (Node.nodeName = surpriseAwardSTable)
   or (Node.nodeName = MultiAwardSTable)
  then
  begin
    Result := '{';
  end;


end;

function TfrmMain.GetXMLValue(FNode,Node: IXMLDOMNode): string;
var
 sValue: string;
begin
  sValue:= Node.nodeValue;
  sValue:= Trim(sValue);

  if  (Node.nodeName = RoleNameAtbName)
   or (Node.nodeName = dataAttr)
   or (Node.nodeName = dataMonsterAttr)
   or (Node.nodeName = entityNameAttr)
   or (Node.nodeName = RoleDescSecName)
   or (Node.nodeName = RolePromulgationNPC)
   or (Node.nodeName = actionDescAttr)
   or (Node.nodeName = RoleAcceptMap)
   or (Node.nodeName = datastrAttr) then
  begin
    if (sValue <> '') and (sValue <> '0') then
     Result := Format('%s = Lang[%s],',[Node.nodeName, sValue])
    else
     Result := Format('%s = "",',[Node.nodeName]);

  end else
  if  (Node.nodeName = RolePromTalkSecName)
   or (Node.nodeName = RoleCompTalkSecName)
   or (Node.nodeName = RoleAcceptStorySecName)
   or (Node.nodeName = RoleFinishStorySecName)
  then
  begin
    if (sValue <> '') and (sValue <> '0') then
     Result := Format('%s = { Lang[%s], },',[Node.nodeName, sValue])
    else
     Result := Format('%s = { "", },',[Node.nodeName]);
  end else
  if  (Node.nodeName = TagAttr)
   or (Node.nodeName = initAttrsAttr) 
  then
  begin
     Result := '';
  end;
end;


//procedure TfrmMain.PublishCBP;
//const
//  TaskLuaFile = 'language = { name = "..\..\data\language\%lang%.db", }'#13#10+
//                 'files = {{'#13#10+
//                   'source = "..\..\data\config\quest\StdQuests.txt",'#13#10+
//                   'dest = "..\..\..\Client\lang\%lang%\stdquest.cbp",'#13#10+
//                   'table = "StdQuest",'#13#10+
//                   'define = { LANGUAGE = "%lang%" },'#13#10+
//                   'filters = {'#13#10+
//                      #9'"*.CompMsTip",'#13#10+
//                      #9'"*.PromMsTalks",'#13#10+
//                      #9'"*.CompMsTalks",'#13#10+
//                      #9'"*.PromCheck",'#13#10+
//                      #9'"*.PromCheckArg",'#13#10+
//                      #9'"*.PromCallBack",'#13#10+
//                      #9'"*.PromCallBackArg",'#13#10+
//                      #9'"*.GiveUpCallBack",'#13#10+
//                      #9'"*.GiveUpCallBackArg",'#13#10+
//                      #9'"*.PassMsTip",'#13#10+
//                      #9'"*.automount",'#13#10+
//                      #9'"*.AnswerTip",'#13#10+
//                      #9'"*.multiAward",'#13#10+
//                      #9'"*.doubleYB",'#13#10+
//                   '},'+
//                 '},}';
//var
//  S: string;
//  strList: TStringList;
//begin
//  strList := TStringList.Create;
//  try
//    S := TaskLuaFile;
//    S := StringReplace(S,'%lang%', LanguagePackage.LanguageName, [rfReplaceAll]);
//    S := StringReplace(S,'\', '/', [rfReplaceAll]);
//    strList.Text := S;
//    strList.SaveToFile(G_CbpPath+'\'+sCBPFileDir+sLuaToCbpTempFile);
//    frmMain.GenLuaCBPFile(G_CbpPath+'\'+sCBPFileDir+sLuaToCbpTempFile);
//  finally
//    DeleteFile(G_CbpPath+'\'+sCBPFileDir+sLuaToCbpTempFile);
//    strList.Free;
//  end;
//end;

procedure TfrmMain.PublishCBP;
var
  Generator: TXCBPGenerator;
  I: Integer;
  RootNode: IXMLDOMNode;
  NodeList: IXMLDOMNodeList;
  procedure FillAttrsText(RootNode: IXMLDOMNode; NodePath: WideString; AttrName: WideString);
  var
    I: Integer;
    Nodes: IXMLDOMNodeList;
    Element: IXMLDOMElement;
  begin
    Nodes := RootNode.selectNodes('//' + NodePath);
    for I := 0 to Nodes.length - 1 do
    begin
      Element := Nodes.item[I] as IXMLDOMElement;
      Element.setAttribute(AttrName, LanguagePackage.GetLangText(RoleLangCategoryId,TryGetAttrValue(Element, AttrName)));
    end;
  end;
begin
  Generator := TXCBPGenerator.Create;
  try
    //ע��ڵ���������
    Generator.ClearNodeDesc();
    for I := Low(RoleInfoXMLNodePathDataTypes) to High(RoleInfoXMLNodePathDataTypes) do
    begin
      Generator.RegisterNodeDesc(RoleInfoXMLNodePathDataTypes[I].NodePath,
        RoleInfoXMLNodePathDataTypes[I].DataType,
        RoleInfoXMLNodePathDataTypes[I].NameType);
    end;
    //��¡���ڵ㣬�������нڵ��д����ַ���ID�ĸ���Ϊ���԰��е��ַ�������
    RootNode := frmMain.m_Xml.createElement(RoleMainSecName);
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for i := 0 to NodeList.length - 1 do
    begin
     RootNode.appendChild(NodeList[i].cloneNode(True))
    end;
    FillAttrsText(RootNode, RoleSecName, RoleNameAtbName);
    FillAttrsText(RootNode, locationesAttr, entityNameAttr);
  //  FillAttrsText(RootNode, locationAttr, entityNameAttr);
    FillAttrsText(RootNode, PassAttr, PassentityNameAttr);
    FillAttrsText(RootNode, RoleSecName, RoleDescSecName);
    FillAttrsText(RootNode, PromAttr, RolePromulgationNPC);
    FillAttrsText(RootNode, CompAttr, RolePromulgationNPC);
    FillAttrsText(RootNode, CompAttr, RoleAcceptMap);
    FillAttrsText(RootNode, PromAttr, RoleAcceptMap);
    FillAttrsText(RootNode, RoleAwardSecName, datastrAttr);
    FillAttrsText(RootNode, RoleItemSecName, dataAttr);

    //����CBP�ļ�
    Generator.BuildCBPFile(RootNode as IXMLDOMElement, G_CbpPath + sCBPFileDir + CbpFileName);
  finally
    Generator.Free;
  end;
end;



procedure TfrmMain.PublishLUA;
const
  sStdItem = '--#include "quests/task%s.txt"';
begin
  with TXmlToLua.Create do
  begin
    sMainFile := G_DataPath+'config\quest\StdQuests.txt';
    sChildFile := G_DataPath+'config\quest\quests\task%s.txt';
    bFilterZero := False;
    OnGetXMLValue := GetXMLValue;
    OnGetXMLNode := GetXMLNode;
    XmlToLua(m_MainNode.selectNodes('//'+RoleSecName), sStdItem, RoleIdAtbName, 'StdQuest');
    Free;
  end;
end;


procedure TfrmMain.btBatchUPdateClick(Sender: TObject);
var
 ikind, irate:Byte;
 I, oldValue: Integer;
 NodeList: IXMLDOMNodeList;
 Ele: IXMLDOMElement;
begin
 Baddtion := false;
 if GetBUPinfo(ikind, irate) then
 begin
   case ikind of
    0: //�������Ԫ����   speedYbAttr
    begin
      NodeList := m_MainNode.selectNodes('//' + RoleSecName);
      for I := 0 to NodeList.length -1 do
      begin
       Ele := NodeList[i] as IXMLDOMElement;
       oldValue := ele.getAttribute(speedYbAttr);
       Ele.setAttribute(speedYbAttr, oldValue * irate)
      end;
    end;
    1://�౶����.3 Ԫ�� / 2 ��ȯ     DoubleMoneyTypeAttr entrustAttr
    begin
      NodeList := m_MainNode.selectNodes('//' + RoleSecName + '[@DoubleMoneyType>1]');
      for I := 0 to NodeList.length -1 do
      begin
       Ele := NodeList[i] as IXMLDOMElement;
       oldValue := ele.getAttribute(entrustAttr);
       Ele.setAttribute(entrustAttr, oldValue * irate)
      end;

    end;
    2://����.3 Ԫ�� / 2��ȯ    AgainMoneyTypeAttr   starAttr
    begin
      NodeList := m_MainNode.selectNodes('//' + RoleSecName + '[@AgainMoneyType>1]');
      for I := 0 to NodeList.length -1 do
      begin
       Ele := NodeList[i] as IXMLDOMElement;
       oldValue := ele.getAttribute(starAttr);
       Ele.setAttribute(starAttr, oldValue * irate)
      end;
    end;
    3://������.7 ���   AwardModeAtbName   AWardCountAtbName
    begin
      NodeList := m_MainNode.selectNodes('//' + RoleAwardSecName + '[@type=7]');
      for I := 0 to NodeList.length -1 do
      begin
       Ele := NodeList[i] as IXMLDOMElement;
       oldValue := ele.getAttribute(AWardCountAtbName);
       Ele.setAttribute(AWardCountAtbName, oldValue * irate)
      end;
    end;
   end;
    SaveRoleFile();
 end;
end;

procedure TfrmMain.btn1Click(Sender: TObject);
var
  strFileName, StrPath: string;
begin
  if (G_CbpPath = '') or not DirectoryExists(G_CbpPath) then
  begin
    if not ShowSettings then
      Exit;
  end;

  StrPath := G_CbpPath + sCBPFileDir;
  if not DirectoryExists(StrPath) then
    ForceDirectories(StrPath);

  strFileName := StrPath + CbpFileName;

  PublishLUA;
  PublishCBP;
  publishWebFile();
  Application.MessageBox(PChar(strFileName + '����CBP�ѳɹ����ɣ�'), '��ʾ', MB_OK or MB_ICONINFORMATION);
end;


procedure SaveUTF8File(AContent:string;AFileName: string);
const
 utf8 = #$EF#$BB#$BF;
var
  FStream:TFileStream;
  futf8Bytes: string;
  S: string;
begin
  if FileExists(PAnsiChar(AFileName))  then DeleteFile(PAnsiChar(AFileName));
  FStream:=TFileStream.Create(AFileName,fmCreate);
  futf8Bytes:= AnsiToUtf8(AContent);
  S:=utf8;
  FStream.Write(S[1],Length(S));
  FStream.Write(futf8Bytes[1],Length(futf8Bytes));
  FStream.Free;
end;


function DescCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
var
 i1, i2:Integer;
 s1, s2:string;
begin
  i1 := Pos('|', List[Index1]);
  i2 := Pos('|', List[Index2]);
  s1 := Copy(List[Index1],1,i1);
  s2 := Copy(List[Index2],1,i2);
  TryStrToInt(s1, i1);
  TryStrToInt(s2, i2);
  result := i1 - i2;
end;

procedure TfrmMain.publishWebFile();
const
  sReturn = '%d|%s';
  sTargetDIr = '%s\backstage\';
var
  TempName, savepath, name : string;
  ResultList, templist: TstringList;
  ItemCount, i ,id, iname,itemp, iper, j :Integer;
  Nodes: IXMLDOMNodeList;
begin
    SavePath := format(sTargetDIr, [G_CbpPath]);
    self.Caption := Format('���ڷ�����̨�ļ�[%d(%s)/1]', [1,'��������']);

    ResultList := TStringList.Create;
    templist := TStringList.Create;
    try
      Nodes := m_MainNode.selectNodes('//'+RoleSecName);
      Clipboard.AsText := DocumentName;
      for I := 0 to Nodes.length - 1 do
      begin
       with (Nodes[i] as IXMLDOMElement) do
       begin
        Id := getAttribute(RoleIdAtbName);
        name := getAttribute(RoleNameAtbName);
        if TryStrToInt(name, iname) then
         name := LanguagePackage.GetLangText(ItemLangCategoryId, iname);
        ResultList.Add(Format(sReturn,[Id, name]));
       end;
      end;
      ResultList.CustomSort(DescCompareStrings);

      for i := 0 to ResultList.Count - 1 do
      begin
        TryStrToInt(Copy(ResultList[i],1,Pos('|',ResultList[i])), itemp);
        if i =0 then  iper :=0;
        if i<itemp then
        begin
          for j := iper to itemp - 1 do
          begin
           templist.Add(Format(sReturn,[j, ' ']));
          end;
          templist.Add(ResultList[i]);
          iper := itemp + 1;
        end
        else
           templist.Add(ResultList[i]);
      end;
      TempName := SavePath + LowerCase('stdquests');
      TempName := ChangeFileExt(TempName, '.txt');
      SaveUTF8File(templist.Text, TempName);
      self.Caption := '������̨�ļ��ɹ�';
    finally
      ResultList.Free;
      templist.free;
    end;

end;

function SplitString(const Source, ch: string): TStringList;
var
  sources,temp,temps: String;
  i: integer;
begin
  Result := TStringList.Create;
  sources:=stringreplace(Source,' ','',[rfreplaceall]);
  if sources = '' then exit;
  // ����ǿ��Է����򷵻ؿ��б�
  temp := stringreplace(Sources,' ','',[rfreplaceall]);
  i := pos(ch, Sources);
  while i <> 0 do
  begin
    temps := copy(temp, 0, i - 1);
    if Trim(temps) <> '' then
    Result.add(temps);
    DELETE(temp, 1, i);
    i := pos(ch, temp);
  end;
  Result.add(temp);

end;

procedure TfrmMain.btnInheritedClick(Sender: TObject);
var
 sRoleid:String;
 iRoleid, i, j:integer;
 sRoleids, outlist: tstrings;
begin
 sRoleid := '0';

 if InputQuery('���ɼ̳��ļ�','����ID(��ID��","�ָ�)',sRoleid) then
 begin
  outlist := tstringlist.create();
  try
    sRoleids := SplitString(sRoleid, ',');
    InheritedList.Clear;
    for i := 0 to sRoleids.count-1 do
    begin
      if trystrtoint(sRoleids[i], iRoleid)   then
      begin
       OutInheritedText(iRoleid);
      end;
    end;

     j := 0;
     for I := InheritedList.Count - 1 downto 0  do
     begin
       if Trim(InheritedList[i]) ='0' then  continue;
       j:= j + 1;
       outlist.Add(Format(Sinherited,[InheritedList[i], j]))
     end;

    outlist.SaveToFile(Format(SinheritedFile, [G_CbpPath]));
    ShowMessage('���ɼ̳��ļ��ɹ� ' + Format(SinheritedFile, [G_CbpPath]));
  finally
    sRoleids.Free;
    outlist.free;
  end;

 end;
end;

function TfrmMain.RefreshRoleClass:Boolean;
var
  I     : Integer;
  Node  : IXMLDOMNode;
begin
  ReSetTreeView();
  Node   := nil;
  Result := False;
  m_MainNode := m_Xml.selectSingleNode(RoleMainSecName);
  if nil = m_MainNode then Exit;
  ConfimStatId();
  Result := True;
  for I := 0 to m_MainNode.childNodes.length - 1 do
  begin
    Node  := m_MainNode.childNodes.item[I];
    ReadXmlNode(Node, m_CurTreeNode);
  end;
  RefCurrentRoleClass();
end;

procedure TfrmMain.ReSetTreeView;
begin
  TreeView1.Items.Clear;
  m_CurTreeNode := TreeView1.Items.AddChild(nil, '����ϵͳ');
  m_CurTreeNode.ImageIndex    := 4;
  m_CurTreeNode.SelectedIndex := 4;
end;

function TfrmMain.RoleCanbeDelete(const nRoleId: Integer): Boolean;
Resourcestring
  sQueryText  = '//*[@'+ RoleInheritedAtbName + '=''%d'']';
begin
  Result := m_MainNode.selectSingleNode(Format(sQueryText, [nRoleId])) = nil;
end;

function TfrmMain.SaveRoleFile: Boolean;
begin
  if not IsReadOnly then
  begin
    m_Xml.save(DocumentName);
  end;
  Result := m_Xml.parseError.errorCode = 0;
end;

procedure TfrmMain.TabSet1Change(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  PageControl1.ActivePageIndex := NewTab;
end;

procedure TfrmMain.ToolButton10Click(Sender: TObject);
begin
  LoadDBItems();
  LoadDBMonsters();
  LoadEnvirInfo();
end;

procedure TfrmMain.ToolButton11Click(Sender: TObject);
begin
  BuildRoleRelationTree();
end;

procedure TfrmMain.ToolButton13Click(Sender: TObject);
var
  Nodes: IXMLDOMNodeList;
  I, nFixed: Integer;
  Element, NewElement: IXMLDOMElement;
begin
  nFixed := 0;
  Nodes := m_MainNode.selectNodes( '//' + RoleSecName );
  for I := 0 to Nodes.length - 1 do
  begin
    Element := Nodes.item[I] as IXMLDOMElement;
    if Element.selectSingleNode(RoleItemsSceName) = nil then
    begin
      Element.appendChild(m_Xml.createElement(RoleItemsSceName));
      Inc( nFixed );
    end;
    if Element.selectSingleNode(RoleAwardsSecName) = nil then       
    begin
      Element.appendChild(m_Xml.createElement(RoleAwardsSecName));  
      Inc( nFixed );
    end;
    if Element.selectSingleNode(RoleCondition) = nil then
    begin
      NewElement := m_Xml.createElement(RoleCondition);      
//      NewElement.setAttribute( CondOfWeekAtrName, 0 );
//      NewElement.setAttribute( CondOfTime, 0 );
      Element.appendChild(NewElement);
      Inc( nFixed );
    end;
  end;
  if nFixed > 0 then
    SaveRoleFile();
  Application.MessageBox(PChar('�����ĵ�������' + IntToStr(nFixed) + '������'), nil, MB_ICONINFORMATION);
end;

procedure TfrmMain.ToolButton15Click(Sender: TObject);
begin
  if ShowSettings then
  begin
    Application.MessageBox('�������óɹ���', '��ʾ', MB_ICONINFORMATION);
    Exit;
  end;
end;

procedure TfrmMain.ToolButton1Click(Sender: TObject);
var
  Tree, OldNode: TTreeNode;
begin
  if m_BackList.Count < 1 then
    Exit;
  OldNode       := m_CurTreeNode;
  try
    Tree          := TTreeNode(m_BackList[m_BackList.Count- 1]);
    m_CurTreeNode := Tree;
    RefCurrentRoleClass();
    Tree.Selected := True;
    m_BackList.Delete(m_BackList.Count - 1);
    AddToFront(OldNode);
  except
    m_BackList.Clear;
    m_FrtList.Clear;
    ToolButton1.Enabled := False;
    ToolButton2.Enabled := False;
    m_CurTreeNode := OldNode;
    RefCurrentRoleClass();
  end;
end;

procedure TfrmMain.ToolButton2Click(Sender: TObject);
var
  Tree, OldNode: TTreeNode;
begin
  if m_FrtList.Count < 1 then
    Exit;
  OldNode       := m_CurTreeNode;
  try
    Tree          := TTreeNode(m_FrtList[m_FrtList.Count- 1]);
    m_CurTreeNode := Tree;
    RefCurrentRoleClass();
    Tree.Selected := True;
    m_FrtList.Delete(m_FrtList.Count - 1);
    AddToBack(Tree);
  except
    m_BackList.Clear;
    m_FrtList.Clear;
    ToolButton1.Enabled := False;
    ToolButton2.Enabled := False;
    m_CurTreeNode := OldNode;
    RefCurrentRoleClass();
  end;
end;

procedure TfrmMain.ToolButton3Click(Sender: TObject);
begin
  if ToolButton3.Tag = 0 then
    ToolButton3.Tag := 1
  else
    ToolButton3.Tag := 0;
  ToolButton3.Down  := ToolButton3.Tag = 1;
  Panel3.Visible := ToolButton3.Down;
  Splitter1.Enabled := ToolButton3.Down;
end;

procedure TfrmMain.ToolButton4Click(Sender: TObject);
begin
  if (m_CurTreeNode = nil) or (m_CurTreeNode.Parent = nil) then
    Exit;
  GotoRoleClass(m_CurTreeNode.Parent);
end;

procedure TfrmMain.ToolButton6Click(Sender: TObject);
begin
  TabSet1.TabIndex := 1;
  PageControl1.ActivePageIndex := 1;
end;

procedure TfrmMain.ToolButton9Click(Sender: TObject);
var
  I: Integer;
  SL: TStrings;
  function TestNode(const Node: IXMLDOMNode):Boolean;
  var
    I, nVal: Integer;
  begin
    Result := True;
    if CompareText(Node.nodeName, RoleClassSecName) = 0 then
    begin
      for I := 0 to Node.childNodes.length - 1 do
        TestNode(Node.childNodes.item[I]);
    end;
    if CompareText(Node.nodeName, RoleSecName) = 0 then
    begin
      if Node.attributes.getNamedItem(RoleIdAtbName).nodeValue <> 0 then
        Result := GetRoleNodeById(Node.attributes.getNamedItem(RoleIdAtbName).nodeValue) <> nil;
      if not Result then
      begin
        SL.Add(Format('��������Ч[Name=%s, Id=%d] û���ҵ�������!',
          [LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue),
          Node.attributes.getNamedItem(RoleIdAtbName).nodeValue]));
        Exit;
      end;
      nVal := Node.attributes.getNamedItem(RolePromulgationMap).nodeValue;
      Result := GetMapNPC( nVal, GetPCNPCName(Node as IXMLDOMElement, RolePromulgationNPC) ) <> nil;
      if not Result then
      begin
        SL.Add(Format('��������Ч[Name=%s, Id=%d] û���ҵ�����NPC(%d:%s)!',
                      [LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue),
                      Integer(Node.attributes.getNamedItem(RoleIdAtbName).nodeValue),
                      nVal,
                      GetPCNPCName(Node as IXMLDOMElement, RolePromulgationNPC)]
                      )
              );
        Exit;
      end;       
      nVal := Node.attributes.getNamedItem(RoleAcceptMap).nodeValue;
      Result := GetMapNPC( nVal, GetPCNPCName(Node as IXMLDOMElement, RoleAcceptNPC)) <> nil;
      if not Result then
      begin
        SL.Add(Format('��������Ч[Name=%s, Id=%d] û���ҵ�����NPC(%d:%s)!',
                      [LanguagePackage.GetLangText(RoleLangCategoryId, Node.attributes.getNamedItem(RoleNameAtbName).nodeValue),
                      Integer(Node.attributes.getNamedItem(RoleIdAtbName).nodeValue),
                      nVal,
                      GetPCNPCName(Node as IXMLDOMElement, RoleAcceptNPC)]
                      )
              );
        Exit;
      end; 
    end;
  end;
begin
  SL  := TStringList.Create;
  for I := 0 to m_MainNode.ChildNodes.length - 1 do
    begin
      TestNode(m_MainNode.childNodes.item[I]);
    end;
  if SL.Count = 0 then
    begin
      DoMsgBox('���Խ���޴���,���е���������������ȷ��!', '���Խ��', MB_ICONINFORMATION);
    end
    else begin
      SL.SaveToFile(ExtRactFilePath(ParamStr(0)) + '\������Խ��.txt');
      DoMsgBox('��⵽����������Ч, ���Խ���Ѿ����浽: ' + ExtRactFilePath(ParamStr(0)) + '\������Խ��.txt', '���Խ��', MB_ICONINFORMATION);
      EditTextFile( ExtRactFilePath(ParamStr(0)) + '\������Խ��.txt' );
    end;
  SL.Free;
end;

procedure TfrmMain.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  RoleNode: IXMLDOMNode;
begin
  NPC1.Enabled := False;
  if (TreeView1.Selected.ImageIndex = 0) or (TreeView1.Selected = TreeView1.Items[0]) then
    GotoRoleClass(TreeView1.Selected)
  else begin
//    RoleNode  := GetRoleNodeById(Integer(TreeView1.Selected.Data));
//    if RoleNode <> nil then
//      begin
//        ListView1.Visible := False;
//        frmViewRoleInfo.ShowRoleInfo(RoleNode);
//        frmViewRoleInfo.Show();
//        frmViewRoleInfo.Dock(Panel1, Panel1.ClientRect);
//      end;
  end;
end;

procedure TfrmMain.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: Integer;
  Item: TListItem;
  Tree, TargetTree: TTreeNode;
  Node, TargetNode, NewNode: IXMLDOMNode;
begin
  TargetTree  := TTreeView(Sender).GetNodeAt(X, Y);
  if TargetTree = nil then
    Exit;
  if TargetTree.ImageIndex = 0 then
  begin
    TargetNode  := GetRoleClass(TargetTree);
    if TargetNode = nil then
      Exit;
  end
  else begin
    TargetNode := GetRoleNodeById(Integer(TargetTree.Data));
    if TargetNode = nil then
      Exit;
  end;
  if Source is TListView then
    begin
      for I := 0 to TListView(Source).Items.Count - 1 do
        begin
          Item  := TListView(Source).Items[I];
          if not Item.Selected then
            continue;
          case Integer(Item.SubItems.Objects[0]) of
            0:begin
              Tree  := GetTreeNodeFromListView(Item);              
              if Tree = nil then
                break;
              if FindChildNode(TargetTree, Item.Caption, 0) <> nil then
                begin
                  DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s �ķ���!�ƶ�ʧ��!', [Item.Caption]), '����', MB_ICONSTOP);
                  break;
                end;
              Node  := GetRoleClass(Tree);
              if Node = nil then
                break;
              NewNode := Node.cloneNode(WordBool(-1));
              if NewNode = nil then
                break;
              if Node.parentNode <> nil then
                Node.parentNode.removeChild(Node);
              TargetNode.appendChild(NewNode);
              Tree.MoveTo(TargetTree, naAddChild);
            end
            else begin
{$IF SHOWROLESINTREE}        
              Tree  := FindChildNode(m_CurTreeNode, Item.Caption, 1);
              if Tree = nil then
                break;
{$IFEND}
              if FindChildNode(TargetTree, Item.Caption, 1) <> nil then
                begin
                  DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s ������!�ƶ�ʧ��!', [Item.Caption]), '����', MB_ICONSTOP);
                  break;
                end;
              Node  := GetRoleNodeById(Integer(Item.SubItems.Objects[1]));
              if Node = nil then
                break;
              NewNode := Node.cloneNode(WordBool(-1));
              if NewNode = nil then
                break;
              if Node.parentNode <> nil then
                Node.parentNode.removeChild(Node);
              TargetNode.appendChild(NewNode);
{$IF SHOWROLESINTREE}
              Tree.MoveTo(TargetTree, naAddChild);
{$IFEND}              
            end;
          end;
        end;
    end;
  if Source is TTreeView then
    begin
      Tree        := TTreeView(Sender).Selected;
      if TTreeView(Sender).Selected.Parent = TargetTree then
        Exit;
      if Tree.ImageIndex = 0 then
        Node  := GetRoleClass(Tree)
      else
        Node  := GetRoleNodeById(Integer(Tree.Data));
      if Node = nil then
        Exit;
      if FindChildNode(TargetTree, Tree.Text, 1) <> nil then
        begin
          DoMsgBox(Format('Ŀ��������Ѿ�����һ����Ϊ %s ����Ŀ!�ƶ�ʧ��!', [Tree.Text]), '����', MB_ICONSTOP);
          Exit;
        end;
      if TargetTree.ImageIndex = 0 then
      begin
        NewNode := Node.cloneNode(WordBool(-1));
        if NewNode = nil then
          Exit;
        if Node.parentNode <> nil then
          Node.parentNode.removeChild(Node);
        TargetNode.appendChild(NewNode);
        Tree.MoveTo(TargetTree, naAddChild);
      end
      else begin
        Node.parentNode.removeChild( Node );
        TargetNode.parentNode.insertBefore( Node, TargetNode );
        Tree.MoveTo(TargetTree, naInsert);
      end;
    end;
  SaveRoleFile();
  RefCurrentRoleClass();
end;

procedure TfrmMain.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Tree: TTreeNode;
  function TreeViewCanAccept():Boolean;
  var
    P: TTreeNode;
  begin
    Result := (Tree <> TTreeView(Sender).Selected);
    if not Result then
      Exit;
    P := Tree.Parent;
    while P <> nil do
      if P = TTreeView(Sender).Selected then
        begin
          Result := False;
          break;
        end
        else P := P.Parent;
  end;
  function ListViewCanAccept():Boolean;
  var
    P, S: TTreeNode;
    I: Integer;
  begin
    Result := (Tree.ImageIndex = 0);
    if not Result then
      Exit;
    for I := 0 to TListView(Source).Items.Count - 1 do
      if TListView(Source).Items[I].Selected then
        if Integer(TListView(Source).Items[I].SubItems.Objects[0]) = 0 then
          begin
            S := GetTreeNodeFromListView(TListView(Source).Items[I]);
            Result := S <> TTreeView(Sender).Selected;
            if not Result then
              Exit;
            P := Tree;
            while P <> nil do
              if S = P then
                begin
                  Result := False;
                  break;
                end
                else P := P.Parent;
            break;
          end;
  end;
begin
  Accept  := False;
  Tree    := TTreeView(Sender).GetNodeAt(X, Y);
  if Tree = nil then
    Exit;
  if Source is TTreeView then
    Accept := TreeViewCanAccept();
  if Source is TListView then
    Accept := ListViewCanAccept();
end;

procedure TfrmMain.TreeView1Edited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  DOMNode: IXMLDOMNode;
begin
  S := TrimRight(S);
  DOMNode := GetRoleClass(Node);
  if DOMNode = nil then
    begin
      S := Node.Text;
      Exit;
    end;
  if FindChildNode(Node.Parent, S, Integer(Node.Data <> nil)) <> nil then
    begin
      DoMsgBox('�Ѿ�����ͬ����Ŀ��', '����', MB_ICONSTOP);
      S := Node.Text;
      Exit;
    end;
  LanguagePackage.ReplaceLangText(RoleLangCategoryId, (DOMNode as IXMLDOMElement).getAttribute(RoleClassNameAtbName),S);
  SaveRoleFile();
end;

procedure TfrmMain.TreeView1Editing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := Node.Parent <> nil;
end;

function TfrmMain.UpDateDocument: Boolean;
var
  Node: IXMLDOMNode;
  sVersion, sNewVersion  : string;
  // ����   ͨ������Ѱ· Ĭ��ֵΪtrue
  procedure UpDateToDoc_130415();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(randomTargetAttr, 'false');
     attnode := Ele.getAttributeNode(RolePromulgationMap);
     Ele.removeAttributeNode(attnode);
     attnode := Ele.getAttributeNode(RolePromulgationNPC);
     Ele.removeAttributeNode(attnode);
     attnode := Ele.getAttributeNode(PromisFPAttr);
     Ele.removeAttributeNode(attnode);
    end;
    sNewVersion := ROLEVERSION_130415;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_13041502();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   subNode: IXMLDOMNode;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     subNode := Ele.selectSingleNode('cond');
     if subNode <> nil then  Ele.removeChild(subNode);
    end;
    sNewVersion := ROLEVERSION_13041502;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_130416();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Element: IXMLDOMElement;
   attriNode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + PassAttr);
    for I := 0 to NodeList.length -1 do
    begin
     Element := NodeList[i] as IXMLDOMElement;
     attriNode := Element.getAttributeNode(hideFastTransferAttr);
     Element.removeAttributeNode(attriNode);
    end;
    sNewVersion := ROLEVERSION_130416;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_130417();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     attnode := Ele.getAttributeNode(RolePromulgationMap);
     if attnode<> nil then Ele.removeAttributeNode(attnode);
     attnode := Ele.getAttributeNode(RolePromulgationNPC);
     if attnode<> nil then Ele.removeAttributeNode(attnode);
     attnode := Ele.getAttributeNode(PromisFPAttr);
     if attnode<> nil then Ele.removeAttributeNode(attnode);
    end;
    sNewVersion := ROLEVERSION_130417;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_13041702();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMNode;
  begin
    NodeList := m_MainNode.selectNodes('//' + locationAttr);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     attnode := Ele.parentNode;
     attnode.removeChild(Ele);
    end;
    sNewVersion := ROLEVERSION_13041702;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_130418();
  var
   NodeList: IXMLDOMNodeList;
   i, j: integer;
   AwrodsEle: IXMLDOMElement;
   TagNode: IXMLDOMNode;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleAwardsSecName);
    for I := 0 to NodeList.length -1 do
    begin
     AwrodsEle := NodeList[i] as IXMLDOMElement;
     TagNode := m_Xml.createElement(AwardTagAttr);
     (TagNode as IXMLDOMElement).setAttribute(TagAttr, '�Զ�����ʱ����');
     for j := 0 to AwrodsEle.childNodes.length - 1 do
     begin
      TagNode.appendChild(AwrodsEle.childNodes[j].cloneNode(True));
     end;

     for j := AwrodsEle.childNodes.length - 1 downto 0  do
     begin
      AwrodsEle.removeChild(AwrodsEle.childNodes[j])
     end;
     
     AwrodsEle.appendChild(TagNode)
    end;
    sNewVersion := ROLEVERSION_130418;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  // ����   StatRepeatId ���ظ�ִ�е�����ID
  procedure UpDateToDoc_130508();
  var
   Ele: IXMLDOMElement;
  begin
    Ele  := m_MainNode.selectSingleNode(RoleStatSecName) as IXMLDOMElement;
    Ele.setAttribute(StatRepeatId, RepeatStartID);

    sNewVersion := ROLEVERSION_130508;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  // ����   ��ϲ����
  procedure UpDateToDoc_130723();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
      NodeList[i].appendChild(m_Xml.createElement(surpriseAwardTable))
    end;
    sNewVersion := ROLEVERSION_130723;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  // ����  �౶����
  procedure UpDateToDoc_130802();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(doubleYBAttr, 'false');
     Ele.setAttribute(entrustAttr, defint);
     Ele.setAttribute(multiAwardAttr, defint);
    end;
    sNewVersion := ROLEVERSION_130802;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  // ����   ��ϲ����
  procedure UpDateToDoc_130807();
  var
   NodeList: IXMLDOMNodeList;
   Nodetemp: IXMLDOMNode;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Nodetemp := NodeList[i].selectSingleNode(surpriseAwardTable);
     if Nodetemp = nil then
      NodeList[i].appendChild(m_Xml.createElement(surpriseAwardTable))
    end;
    sNewVersion := ROLEVERSION_130807;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;


  // ����  �౶����
  procedure UpDateToDoc_130809();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(starAttr, defint);
    end;
    sNewVersion := ROLEVERSION_130809;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_130903();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     attnode := Ele.getAttributeNode(doubleYBAttr);
     if attnode<> nil then Ele.removeAttributeNode(attnode);
     Ele.setAttribute(DoubleMoneyTypeAttr, defint);
     Ele.setAttribute(AgainMoneyTypeAttr, defint);
    end;
    sNewVersion := ROLEVERSION_130903;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_13090302();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(DoubleMoneyTypeAttr, 3);
     Ele.setAttribute(AgainMoneyTypeAttr, 3);
    end;
    sNewVersion := ROLEVERSION_13090302;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_130909();
  var
   NodeList: IXMLDOMNodeList;
   i,temp: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleAwardSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     temp := ele.getAttribute(AWardItemBindAtbName);
     if temp=-1 then
     Ele.setAttribute(AWardItemBindAtbName, 1);
    end;
    sNewVersion := ROLEVERSION_130909;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  //������˫����ȡ��Ԫ�������޸ĳ���ȯ����
  procedure UpDateToDoc_130912();
  var
   strSelect : string;
   NodeList: IXMLDOMNodeList;
   i,temp: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    strSelect := '//' + RoleSecName + '[@type=''0'']';
    NodeList := m_MainNode.selectNodes(strSelect);

    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(DoubleMoneyTypeAttr, 2);
    end;
    sNewVersion := ROLEVERSION_130912;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;


  procedure UpDateToDoc_130917();
  var
   NodeList: IXMLDOMNodeList;
   i,temp: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleAwardSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     temp := ele.getAttribute(AWardItemBindAtbName);
     if temp=1 then
      Ele.setAttribute(AWardItemBindAtbName, GetLuaBoolstr(true))
     else
      Ele.setAttribute(AWardItemBindAtbName, GetLuaBoolstr(false));
    end;
    sNewVersion := ROLEVERSION_130917;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_140412();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(notGiveAwardAttr, GetLuaBoolstr(False))
    end;
    sNewVersion := ROLEVERSION_140412;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  // ����   �౶����
  procedure UpDateToDoc_140421();
  var
   NodeList: IXMLDOMNodeList;
   Nodetemp: IXMLDOMNode;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Nodetemp := NodeList[i].selectSingleNode(MultiAwardTable);
     if Nodetemp = nil then
      NodeList[i].appendChild(m_Xml.createElement(MultiAwardTable))
    end;
    sNewVersion := ROLEVERSION_140421;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  procedure UpDateToDoc_140424();
  var
   NodeList: IXMLDOMNodeList;
   Nodetemp: IXMLDOMNode;
   i: integer;
   Ele: IXMLDOMElement;
   attnode: IXMLDOMAttribute;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName + '[@multiAward=4]');
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     with Ele do
     begin
      setAttribute(multiAwardAttr, defint);
      setAttribute(DoubleMoneyTypeAttr, defint);
      setAttribute(entrustAttr, defint);
     end;
    end;
    sNewVersion := ROLEVERSION_140424;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;

  //��������������ʾ����
  procedure UpDateToDoc_140523();
  var
   NodeList: IXMLDOMNodeList;
   i: integer;
   Ele: IXMLDOMElement;
  begin
    NodeList := m_MainNode.selectNodes('//' + RoleSecName);
    for I := 0 to NodeList.length -1 do
    begin
     Ele := NodeList[i] as IXMLDOMElement;
     Ele.setAttribute(RoleAutoCompleteAttrName, defBool);
    end;
    sNewVersion := ROLEVERSION_140523;
    (Node as IXMLDOMElement).setAttribute( RoleVersionAttribute, sNewVersion );
  end;


begin
  m_MainNode  := m_Xml.selectSingleNode(RoleMainSecName);
  Result := False;
  if nil = m_MainNode then
    Exit;
  Node  := m_MainNode.selectSingleNode(RoleVersion);
  if Node <> nil then
  begin     
    sVersion := Node.attributes.getNamedItem(RoleVersionAttribute).text;
    sNewVersion := sVersion;

    if CompareText( sNewVersion, ROLEVERSION_130409 ) = 0 then
    begin
      UpDateToDoc_130415();
      Result := UpDateDocument();
    end;

    if CompareText( sNewVersion, ROLEVERSION_130415 ) = 0 then
    begin
      UpDateToDoc_13041502();
      Result := UpDateDocument();
    end;

    if CompareText( sNewVersion, ROLEVERSION_13041502 ) = 0 then
    begin
      UpDateToDoc_130416();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130416 ) = 0 then
    begin
      UpDateToDoc_130417();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130417 ) = 0 then
    begin
      UpDateToDoc_13041702();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_13041702) = 0 then
    begin
      UpDateToDoc_130418();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130418) = 0 then
    begin
      UpDateToDoc_130508();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130508) = 0 then
    begin
      UpDateToDoc_130723();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130723) = 0 then
    begin
      UpDateToDoc_130802();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130802) = 0 then
    begin
      UpDateToDoc_130807();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130807) = 0 then
    begin
      UpDateToDoc_130809();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130809) = 0 then
    begin
      UpDateToDoc_130903();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130903) = 0 then
    begin
      UpDateToDoc_13090302();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_13090302) = 0 then
    begin
      UpDateToDoc_130909();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130909) = 0 then
    begin
      UpDateToDoc_130912();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130912) = 0 then
    begin
      UpDateToDoc_130917();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_130917) = 0 then
    begin
      UpDateToDoc_140412();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_140412) = 0 then
    begin
      UpDateToDoc_140421();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_140421) = 0 then
    begin
      UpDateToDoc_140424();
      Result := UpDateDocument();
    end;
    if CompareText( sNewVersion, ROLEVERSION_140424) = 0 then
    begin
      UpDateToDoc_140523();
      Result := UpDateDocument();
    end;


    if sNewVersion <> sVersion then
    begin
      Result := true;
      Application.MessageBox( '�����ĵ��ѱ����������°汾��', '��ʾ', MB_ICONINFORMATION )
    end;
    if CompareText( sNewVersion, CURRENTROLE_VERSION ) = 0 then
    begin
       Result := True;
       Exit;
    end;
  end
  else begin
    Application.MessageBox( '����Ч�����������ĵ�', '����', MB_ICONSTOP );
    Halt( 0 );
  end;
end;


procedure TfrmMain.DisplaySearchAwardResult(const Nodes: IXMLDOMNodeList);
var
  I: Integer;
  RoleID: string;
  Element: IXMLDOMElement;
  AwardList: TStrings;
begin
  AwardList := TStringList.Create;
  try
    ListViewSearchResult.Items.Clear;
    for I := 0 to Nodes.length - 1 do
    begin
      Element := Nodes.item[I].parentNode.parentNode.parentNode as IXMLDOMElement;
      RoleID := Element.getAttribute(RoleIdAtbName);
      if AwardList.IndexOf(RoleID) < 0 then
      begin
        AwardList.Add(RoleID);
        with ListViewSearchResult.Items.Add do
        begin
          Caption := RoleID;
          Data := Pointer(StrToInt(Caption));
          SubItems.Add( LanguagePackage.GetLangText(RoleLangCategoryId, Element.getAttribute( RoleNameAtbName )) );
        end;
      end;
    end;
  finally
    AwardList.Free;
  end;
end;

procedure TfrmMain.DisplaySearchResult(const Nodes: IXMLDOMNodeList);
var
  I: Integer;
  Element: IXMLDOMElement;
begin
  ListViewSearchResult.Clear();
  for I := 0 to Nodes.length - 1 do
  begin
    with ListViewSearchResult.Items.Add do
    begin
      Element := Nodes.item[I] as IXMLDOMElement;
      Caption := Element.getAttribute( RoleIdAtbName );
      Data := Pointer(StrToInt(Caption));
      SubItems.Add( LanguagePackage.GetLangText(RoleLangCategoryId, Element.getAttribute( RoleNameAtbName )) );
    end;
  end;
end;

procedure TfrmMain.SearchByID(const nId: Integer);
Resourcestring
  sQuery = '//' + RoleSecName + '[@' + RoleIdAtbName + '="%d"]';
begin
  DisplaySearchResult( frmMain.m_MainNode.selectNodes( Format(sQuery, [nId]) ) );
end;

procedure TfrmMain.SearchByName(const sName: string);
var
  I: Integer;
  Element : IXMLDOMElement;
  NodeList: IXMLDOMNodeList;
begin
  NodeList := frmMain.m_MainNode.selectNodes('//'+RoleSecName);
  for I := 0 to NodeList.length - 1 do
  begin
    Element := NodeList[I] as IXMLDOMElement;
    if LanguagePackage.GetLangText(RoleLangCategoryId,Element.getAttribute(RoleNameAtbName)) = sName then
    begin
      SearchByID(Element.getAttribute(RoleIdAtbName));
      break;
    end;
  end;
end;

function TfrmMain.SearchByID2(const nId: Integer): IXMLDOMNode;
Resourcestring
  sQuery = '//' + RoleSecName + '[@' + RoleIdAtbName + '="%d"]';
begin
  Result := frmMain.m_MainNode.selectSingleNode(Format(sQuery, [nId]));
end;

procedure TfrmMain.OutInheritedText(const nId: Integer);
var
 TempNode :IXMLDOMNode;
 i, j, iTempID: Integer;
 TempList:TStringList;
begin
 TempNode :=SearchByID2(nid);
 if Assigned(TempNode) then
 begin
   iTempID := TempNode.attributes.getNamedItem(RoleIdAtbName).nodeValue;
   InheritedList.Add(IntToStr(iTempID));
   iTempID := TempNode.attributes.getNamedItem(RoleInheritedAtbName).nodeValue;
   InheritedList.Add(IntToStr(iTempID));
   while SearchByID2(iTempID)<>nil  do
   begin
     TempNode := SearchByID2(iTempID);
     iTempID := TempNode.attributes.getNamedItem(RoleInheritedAtbName).nodeValue;
     InheritedList.Add(IntToStr(iTempID));
   end;
 end;
end;



procedure TfrmMain.SearchByMap(const sMap: string);
Resourcestring
  sQuery = '//' + RoleSecName + '[@' + RolePromulgationMap + '="%d" or @' + RoleAcceptMap + '="%d"]';
var
  Map: TRoleEnvir;
begin
  Map := frmMain.GetMap( sMap );
  if Map <> nil then
  begin
    DisplaySearchResult( frmMain.m_MainNode.selectNodes( Format(sQuery, [Map.MapId, Map.MapId]) ) );
  end
  else Raise Exception.Create( '��ͼδ�ҵ���' );
end;  

procedure TfrmMain.SearchRoleAward(const Award: string);
Resourcestring
  sQuery = '//' + RoleAwardSecName + '[@' + AwardModeAtbName + '="%d"]';
var
  S: string;
  ModeID: Integer;
  AwardList: TStrings;
begin
  AwardList := TStringList.Create;
  try
    for S in RoleAwardModeStr do
      AwardList.Add(S);
    ModeID := AwardList.IndexOf(Award);
    DisplaySearchAwardResult(frmMain.m_MainNode.selectNodes( Format(sQuery, [ModeID]) ));
  finally
    AwardList.Free;
  end;
end;

procedure TfrmMain.SetCountrysExecuteId;
var
  I: Integer;
begin
  for I := 0 to m_Countrys.Count - 1 do
  begin
    m_Countrys.Objects[I] := TObject(I+1);
  end;    
end;

procedure TfrmMain.SetDocumentOpened(boOpened: Boolean);
begin
  DocStateCheck.CloseDocState(DocStateName);
end;

procedure TfrmMain.SearchAwardItems(const Items: string);
Resourcestring
  sQuery = '//' + RoleAwardSecName + '[@' + AWardItemIdAtbName + '="%d"]';
var
  Idx: Integer;
begin
  Idx := m_DBItems.IndexOf(Items);
  if Idx > -1 then
  begin
    ListViewSearchResult.Items.Clear;
    DisplaySearchAwardResult(frmMain.m_MainNode.selectNodes( Format(sQuery, [Integer(m_DBItems.Objects[Idx])]) ));
  end;
end;

procedure TfrmMain.SearchByNPC(const pname,NodeName,sNPC: string);
var
  I: Integer;
  NpcName: string;
  Element, tElement: IXMLDOMElement;
  NodeList: IXMLDOMNodeList;
begin
  ListViewSearchResult.Clear();
  NodeList := frmMain.m_MainNode.selectNodes( '//' + RoleSecName );
  for I := 0 to NodeList.length - 1 do
  begin
    Element := NodeList[I] as IXMLDOMElement;
    tElement := Element.selectSingleNode(pname) as IXMLDOMElement;
    NpcName := LanguagePackage.GetLangText(RoleLangCategoryId, tElement.getAttribute(NodeName));
    if NpcName = sNPC then
    begin
      with ListViewSearchResult.Items.Add do
      begin
        Caption := Element.getAttribute( RoleIdAtbName );
        Data := Pointer(StrToInt(Caption));
        SubItems.Add( LanguagePackage.GetLangText(RoleLangCategoryId, Element.getAttribute( RoleNameAtbName )) );
      end;
    end;
  end;
end;

procedure TfrmMain.RadioGroupSearchModeClick(Sender: TObject);
const
  sLabelStrs : array [0..6] of string = ( '����ID', '��������', '�����ͼ', '����NPC', '����NPC', '������', '������Ʒ');
begin
  LabeSearchMode.Caption := sLabelStrs[RadioGroupSearchMode.ItemIndex] + ':';
end;

{ TRoleEnvir }

procedure TRoleEnvir.ClearListObjects;
var
  I: Integer;
begin
  for I := 0 to AStringList.Count - 1 do
  begin
    AStringList.Objects[I].Free;
  end;
  AStringList.Clear();
end;

constructor TRoleEnvir.Create;
begin
  m_NPCList := TStringList.Create;
  m_NPCList.Sorted := True;
  m_NPCList.CaseSensitive := False;   
  m_NPCList.Duplicates := dupAccept;
  m_MonList := TStringList.Create;
//  m_MonList.Sorted := True;
  m_MonList.CaseSensitive := False;
  m_MonList.Duplicates := dupAccept;
end;

destructor TRoleEnvir.Destroy;
begin
  ClearListObjects( m_NPCList );  
  ClearListObjects( m_MonList );
  m_NPCList.Free;
  m_MonList.Free;
  inherited;
end;


function TRoleEnvir.Getobject(const langid: Integer): Tobject;
var
  i: Integer;
begin
  Result := nil;
  if langid <> 0 then
  begin
    for I := 0 to m_NPCList.Count - 1 do
    begin
      if TEnvirNPC(m_NPCList.Objects[I]).NPCLangID = langid then
      begin
       Result := m_NPCList.Objects[I] ;
       Break;
      end;
    end;
    if Result = nil then
    for I := 0 to m_MonList.Count - 1 do
    begin
      if TEnvirMonster(m_MonList.Objects[I]).MonLangid = langid then
      begin
       Result := m_MonList.Objects[I] ;
       Break;
      end;
    end;
  end;
end;



function TRoleEnvir.GetNPC(const sNPCName: string): TEnvirNPC;
var
  nIdx: Integer;
begin
  Result := nil;
  if sNPCName <> '' then
  begin
    nIdx := m_NPCList.IndexOf(sNPCName);
    if nIdx > -1 then
      Result := TEnvirNPC(m_NPCList.Objects[nIdx])
  end;
end;

function TRoleEnvir.GetMonster(const sMonName: string): TEnvirMonster;
var
  nIdx: Integer;
begin
  nIdx := m_MonList.IndexOf(sMonName);
  if nIdx > -1 then
    Result := TEnvirMonster(m_MonList.Objects[nIdx])
  else Result := nil;
end;

{ TCustomEnvirObject }

destructor TCustomEnvirObject.Destroy;
begin

  inherited;
end;

end.
