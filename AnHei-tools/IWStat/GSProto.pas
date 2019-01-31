unit GSProto;

interface

const
  //��̨��������---�ͻ���
  CM_REGIST_SERVER_RET  = 1000; //������������
  CM_RELOADDATALL       = 1001; //���¼���ȫ������
  CM_RELOADNPC          = 1002; //���¼���NPC
  CM_RELOAD_FUNCTION    = 1003;
  CM_REFRESHCORSS       = 1004; //ˢ�¿������
  CM_RELOADCONFIG       = 1005; //ˢ����������
  CM_RELOADLANG         = 1006; //ˢ�����԰�
  CM_IW_PAYALL          = 1007; //ƽ̨���ݻ���
  //��̨��������---�����
  SM_REGIST_SERVER      = 2000; //����˷�����������
  SM_RELOADDATALL       = 2001; //���¼���ȫ������ ��̨�б���Ϣ
  SM_RELOADNPC          = 2002; //���¼���NPC
  SM_RELOAD_FUNCTION    = 2003; //ˢ�¹��ܽű�
  SM_REFRESHCORSS       = 2004; //ˢ�¿������
  SM_RELOADCONFIG       = 2005; //ˢ����������
  SM_RELOADLANG         = 2006; //ˢ�����԰�
  SM_IW_PAYALL          = 1007; //ƽ̨���ݻ���

  //��̨���߼�ͨѶ-----------------------------------
  MSS_REGIST_SERVER_RET = 10000; //��Ӧע����������(tagΪ0��ʾ�ɹ�)
  MSS_KEEP_ALIVE        = 10001; //��������
  MSS_RELOADNPC         = 10002; //ˢ��NPC(���ݶ�ΪEncode(��ͼ���� + \n + NPC����))
  MSS_RELOADNOTICE      = 10003; //ˢ�¹���
  MSS_KICKPLAY          = 10004; //�߽�ɫ���ߣ����ݶ�Ϊ�����Ľ�ɫ���ƣ�
  MSS_KICKUSER          = 10005; //���˺����ߣ����ݶ�Ϊ�������˺��ַ�����
  MSS_QUERYPLAYONLINE   = 10006; //��ѯ��ɫ�Ƿ����ߣ����ݶ�Ϊ�����Ľ�ɫ���ƣ�
  MSS_QUERYUSERONLINE   = 10007; //��ѯ�˺��Ƿ����ߣ����ݶ�Ϊ�������˺��ַ�����
  MSS_ADDNOTICE         = 10008; //��ӹ���
  MSS_DELNOTICE         = 10009; //ɾ������
  MSS_DELAY_UPHOLE      = 10010; //���뵹��ʱά��״̬(param=����ʱ����)
  MSS_CANLCE_UPHOLE     = 10011; //ȡ������ʱά��״̬
  MSS_SET_EXPRATE       = 10012; //���þ��鱶��(paramΪ���ʣ�1��ʾ1����2��ʾ2��)
  MSS_SHUTUP            = 10013; //����(Param = ʱ��, ��λ�Ƿ���,���ݶ�Ϊ�����Ľ�ɫ����)
  MSS_RELEASESHUTUP     = 10014; //����ԣ����ݶ�Ϊ�����Ľ�ɫ���ƣ�
  MSS_RELOAD_FUNCTION   = 10015; //ˢ�¹��ܽű�
  MSS_APPLY_ACROSS_SERVER_RET = 10016;//��̨���ص����������  Tag = 0 Ϊ�ɹ�, 1 Ϊʧ��  ���ݶ�Ϊ:  ����Ľ�ɫ��
  MSS_GET_ARENA_SCORE_RANK    = 10017; //��̨���������ȡ��̨�������а�
  MSS_RELOAD_LOGIN_SCRIPT     = 10018; //��̨���¼��ص�½�ű�
  MSS_RELOAD_ROBOTNPC         = 10019; //��̨���¼��ػ����˽ű�
  MSS_RELOAD_SHOP             = 10020; //��̨���¼����̳���Ʒ
  MSS_GET_CURR_PROCESS_MEM_USED  = 10021; //��ȡ���浱ǰ���ڴ�ʹ����(�ӽ�2G����Σ��״̬,�����ױ���)
  MSS_ADD_PLAYER_RESULTPOINT     = 10022; //������ҵķ�����(��Ԫ��),RecogΪ��Ԫ����ֵ, ����������,��Ϊ����ʱ���Ǽ�����ҵİ�Ԫ��, ���ݶ�Ϊ��ɫ����.
  MSS_RELOAD_ABUSEINFORMATION    = 10023; //���¼������ַ��Թ�����Ϣ��
  MSS_RELOAD_MONSTER_SCRIPT      = 10024; //���¼��ع���ű������ݶ�Ϊ�����Ľ�ɫ����)
  MSS_OPEN_GAMBLE                = 10025; //�����Ĳ�ϵͳ
  MSS_CLOSE_GAMBLE               = 10026; //�رնĲ�ϵͳ
  MSS_OPEN_COMMONSERVER  = 10027; //�������
  MSS_CLOSE_COMMONSERVER = 10028; //�رտ��
  MSS_SEND_OFFMSGTOACOTOR	 = 10029;	//��̨�����ֱ�ӷ���������Ϣ  ���ݶ�Ϊ(��ɫ���� + \n +�ظ�����Ϣ����)��
	MSS_OPEN_COMPENSATE		 = 10030;	//��̨�������� ���ݶ�Ϊ��(paramΪ��������ID Tag��ʾ����ʱ��(����))
	MSS_CLOSE_COMPENSATE	 = 10031;	//��̨�رղ��� ���ݶ�Ϊ��(��������ID)
  MSS_ADD_FILTERWORDS		 = 10032;	//��̨��������� (Param = 0 Ϊ���� 1Ϊɾ�� Tag = 1 ��ӷ��Ե������� 2 ��Ӵ�����ɫ�������֣�
  MSS_SET_DROPRATE		   = 10033;	//��̨���ú����������� param:1�ױ���2��װ��3�챳��4��װ, Tag�����ʣ��ٷ���)
  MSS_SET_QUICKSOFT		   = 10034;	//��̨������ҵ�����   ����Param ��intֵ
  MSS_SET_CHATLEVEL		   = 10035;	//��̨��������ȼ�  Param ��Ƶ��id, Tag����С�ȼ�
  MSS_SET_DELGUILD       = 10036; //��̨ɾ���л�
  MSS_SET_HUNDREDSERVER  = 10037;	//��̨���ðٷ��
  MSS_SET_RELOADCONFIG	 = 10038;	//��̨������������
	MSS_SET_REMOVEITEM	   = 10039;	//ɾ����ҵ���Ʒ  ���� ��ƷGUID λ��
	MSS_SET_REMOVEMONEY		 = 10040;	//ɾ����ҽ�Ǯ		����  ���� Ǯ����
  MSS_DELAY_COMBINE		   = 10041;	//��̨���úϷ�����ʱ
  MSS_GET_NOTICESTR		   = 10042;	//��̨���󹫸��б�
  MSS_SET_REFRESHCORSS	 = 10043;	//��̨ˢ�¿������
  MSS_SET_COMMON_SRVID   = 10044; //���ÿ���ķ�����ID
  MSS_GET_COMMON_SRVID	 = 10045; //��ȡ����ķ�����Id
  MSS_SET_SURPRISERET		 = 10046;	//��̨���þ�ϲ����(Tag:��ID��paramΪ������ʱ�䣨Сʱ������������ʱ��,��ʽ�磺2013-01-01 10:0:0)
  MSS_RESET_GAMBLE	  	 = 10047;	//����Ѱ��Ԫ������
  MSS_SET_CHANGENAME   	 = 10048;	//���ø����ֹ��� Param 0Ϊ�ر� 1Ϊ����
  MSS_SET_OLDPLAYERBACK  = 10049;	//��������һع� Param 0Ϊ�ر� 1Ϊ����
  MSS_SET_RELOADLANG	   = 10050;	//�������԰�
  MSS_SET_GROUPON	       = 10051;	//��̨�����Ź�(Tag:��ID��ID=0��ʾ�鿴����״̬����paramΪ������ʱ�䣨Сʱ��������ʱ��Ϊ0��ʾ�رգ�����������ʱ��,��ʽ�磺2013-01-01 10:0:0)
  MSS_SET_CROSSBATTLE    = 10052;	//�������������ħս�� Tag	0 �ر� 1 ����
  MSS_SET_CROSSBATTLENUM = 10053; //���ÿ����ħս��������
  MSS_RELOAD_ITMEFUNCTION = 10054; //ˢ�µ��߽ű�
  MSS_VIEW_STATE         = 10055; //�鿴ϵͳ����״̬

  MCS_REGIST_SERVER       = 20000; //�������ע��(param=������ID�����ݶ�Ϊ�����ķ���������)
  MCS_KEEP_ALIVE          = 20001; //�ͻ��˻�Ӧ��������
  MCS_RELOADNPC_RET       = 20002; //����ˢ��NPC���(tagΪ0��ʾ�ɹ��������ʾʧ�ܡ�param��ʾ���ص�NPC����)
  MCS_RELOADNOTICE_RET    = 20003; //����ˢ�¹�����(tagΪ0��ʾ�ɹ�,�����ʾʧ�ܣ���ʧ��ʱ���ݶ�Ϊ�����Ĵ��������ַ���)
  MCS_KICKPLAY_RET        = 20004; //�����߽�ɫ���߽��(tagΪ0��ʾ�ɹ���1��ʾ��ɫ������)
  MCS_KICKUSER_RET        = 20005; //�������˺����߽��(tagΪ0��ʾ�ɹ���1��ʾ��ɫ������)
  MCS_QUERYPLAYONLINE_RET = 20006; //���ز�ѯ��ɫ�Ƿ����߽��(tagΪ1��ʾ����)
  MCS_QUERYUSERONLINE_RET = 20007; //���ز�ѯ�˺��Ƿ����߽��(tagΪ1��ʾ����)
  MCS_ADDNOTICE_RET       = 20008; //������ӹ�����(tagΪ0��ʾ�ɹ�)
  MCS_DELNOTICE_RET       = 20009; //����ɾ��������(tagΪ0��ʾ�ɹ���1��ʾ�����ڴ˹�������)
  MCS_DELAY_UPHOLE_RET    = 20010; //���ؽ��뵹��ʱά�����(tagΪ0��ʾ�ɹ�)
  MCS_CANLCE_UPHOLE_RET   = 20011; //����ȡ������ʱά��״̬���(tagΪ0��ʾ�ɹ�)
  MCS_SET_EXPRATE_RET     = 20012; //�������þ��鱶�ʽ��(tagΪ0��ʾ�ɹ���paramΪʵ�����õı��ʣ����ܲ�ͬ���������õı���)
  MCS_SHUTUP_RET          = 20013; //���ؽ��Խ��(tagΪ0��ʾ�ɹ�)
  MCS_RELEASESHUTUP_RET   = 20014; //���ؽ���Խ��(tagΪ0��ʾ�ɹ�)
  MCS_RELOAD_FUNCTION_RET = 20015; //ˢ�¹��ܽű����(tagΪ0��ʾ�ɹ�)
  MCS_APPLY_ACROSS_SERVER = 20016; //����ת������̨����������������Ϣ  Recog = ������ˮ��, Tag = ������ID ���ݶ�����Ϊ:  �˺�����/��ɫ����
  MCS_GET_ARENA_SCORE_RANK_RET= 20017; //��̨���������ȡ��̨�������а��� Param = ��¼�����������ֵΪ50����СֵΪ0��
                                       //���ݶ�Ϊ ���ܺ��������Ϣ��ʽΪ:  ��ɫID/��ɫ��/����ID/ʤ������/ʧ�ܳ���/����ֵ + #13
  MCS_RELOAD_LOGIN_SCRIPT_RET = 20018; //��̨���¼��ص�½�ű����(tagΪ0��ʾ�ɹ�)
  MCS_RELOAD_ROBOTNPC_RET     = 20019; //��̨���¼��ػ����˽ű����(tagΪ0��ʾ�ɹ�)
  MCS_RELOAD_SHOP_RET         = 20020; //��̨���¼����̳���Ʒ���(tagΪ0��ʾ�ɹ�)
  MCS_GET_CURR_PROCESS_MEM_USED_RET = 20021; //��ȡ���浱ǰ���ڴ�ʹ�������(tagΪ0��ʾ�ɹ�,��ʱParamΪ�ڴ�ʹ����,��λ: MB)
  MCS_ADD_PLAYER_RESULTPOINT_RET    = 20022; //��̨��������ӷ���(��Ԫ��)�ķ��ؽ��(tagΪ0��ʾ�ɹ�, 1��ʾ���ﲻ���߻��߽�ɫ������ȷ) 
  MCS_RELOAD_ABUSEINFORMATION_RET   = 20023; //���¼������ַ��Թ�����Ϣ��(tagΪ0��ʾ�ɹ�)
  MCS_RELOAD_MONSTER_SCRIPT_RET     = 20024; //���¼��ع���ű�����(tagΪ0��ʾ�ɹ�)
  MCS_OPEN_GAMBLE          = 20025; //�����Ĳ�ϵͳ����(tagΪ0��ʾ�ɹ�)
  MCS_CLOSE_GAMBLE         = 20026; //�رնĲ�ϵͳ����(tagΪ0��ʾ�ɹ�)
  MCS_OPEN_COMMONSERVER    = 20027; //�������
  MCS_CLOSE_COMMONSERVER   = 20028; //�رտ��
  MCS_SEND_OFFMSGTOACOTOR	 = 20029;	//���غ�̨�����ֱ�ӷ���������Ϣ���(tagΪ0��ʾ�ɹ�)
	MCS_OPEN_COMPENSATE_RET	 = 20030;	//��̨������������ (tagΪ0��ʾ�ɹ� ���򷵻ص�ǰ�����Ĳ�������ID)
	MCS_CLOSE_COMPENSATE_RET = 20031;	//��̨�رղ������� (tagΪ0��ʾ�ɹ�)
	MCS_RETURN_FILTER_RET    = 20032;	//��̨��������֣�tagΪ0��ʾ�ɹ���1 ��ʾ�Ѵ��������֣�2 ��ʾʧ�ܣ�
  MCS_RETURN_DROPRATE_RET	 = 20033; //���غ�̨�����������������ʽ��(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)

	MCS_RETURN_QUICKSOFT_RET   = 20034;	 //������ҵ�����  (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_CHATLEVEL_RET   = 20035;  //��������ȼ� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_DELGUILD_RET    = 20036;  //���غ�̨ɾ���л� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_HUNDREDSERVER   = 20037;	 //�������õİٷ�����
  MCS_RETURN_RELOADCONFIG	   = 20038;  //���غ�̨�����������ý��
	MCS_RETURN_REMOVEITEM	     = 20039;  //����ɾ�������Ʒ��� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
	MCS_RETURN_REMOVEMONEY	   = 20040;	 //����ɾ����ҽ�Ǯ���  (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MSS_DELAY_COMBINE_RET		   = 20041;	 //���غ�̨���úϷ�����ʱ  (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_NOTICESTR		   = 20042;	 //���غ�̨���󹫸��б�
  MCS_RETURN_REFRESHCORSS	   = 20043;	 //���غ�̨ˢ�¿������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_SET_COMMON_SRVID = 20044; //�������ÿ���ķ�����ID (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_GET_COMMON_SRVID = 20045; //���ػ�ȡ����ķ�����Id  (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_SET_SURPRISERET	= 20046; //��̨���þ�ϲ��������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RESET_GAMBLE	  	      = 20047; //����Ѱ��Ԫ������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_CHANGENAME       = 20048; //���غ�̨��������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_OLDPLYBACK       = 20049; //��������һع���(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_RELOADLAND       = 20050; //���ؼ������԰�(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RETURN_SET_GROUPON      = 20051;	//��̨�����Ź�����(tagΪ0��ʾ�ɹ���1��ʾ����ʧ�ܣ�2��ʾ�ѿ�����3û����)

  MCS_RETURN_CROSSBATTLE      = 20052; //���غ�̨���������ħս��(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MSS_RETURN_CROSSBATTLENUM   = 20053; //�������ÿ����ħս�������Ľ�� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
  MCS_RELOAD_ITMEFUNCTION     = 20054; //����ˢ�¹��ܽű���� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
 	MCS_VIEW_STATE	            = 20055; //���ⷵ����Ϣ �鿴ϵͳ����״̬(��ȡ�ַ���)

implementation

end.
