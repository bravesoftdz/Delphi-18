select * from [DBZhuShui]

----����עˮ�ձ��Ĵ���
---------------------------------------
----�ڡ�DR����2010819������������--------
----            ����ʾ��λ��ʦ   -------
----    �밴˳��ִ��,�������Ը� -------
---------------------------------------
use zmm
select * from [dbzhushui]
---���������ۼ�עˮ����������ۼ�עˮ����ô���������ֵ�����죬�����ֵ������
update [DBZhuShui] set todayzsl=yesterdayzsl,yesterdayzsl=todayzsl where yesterdayzsl>=todayzsl

---------ɾ����Ч����Ϣ��
��--------wellnameΪ�յ��У���wellnamea��ֵ��ֵ��wellname(���¸��׶λ��wellname����������)
    update [DBZhuShui] set wellname=wellnamea where wellname is null or wellname=''
  --------�������Ϊ�յ��У�wellname��
    delete  from [DBZhuShui] where wellname is null

��---����wellnamea ���������ֵľ�
  select distinct(wellnamea) from [DBZhuShui] where wellnamea not like '%[123456789]%'
   -----�鿴�쳣���š����Ͷ�,¼����,¼��ʱ�����Ϣ����������Ӧ��excel�в鿴��ȷ����Ϣ�Ƿ���Ч,�������ж�Ҫ��ʾ��λ��ʦ
   --- select depname,biaogemingcheng,inputdate from [dbzhushui] where wellnamea='��������վˮԴ��'
  --��ȷ��֮��ɾ����wellnamea ���������ֵľ�����Ч��
  --delete from [DBZhuShui] where wellnamea not like '%[123456789]%'

��---����wellname ���������ֵľ�
  select distinct(wellname) from [DBZhuShui] where wellname not like '%[123456789]%'
   -----�鿴�쳣���š����Ͷ�,¼����,¼��ʱ�����Ϣ����������Ӧ��excel�в鿴��ȷ����Ϣ�Ƿ���Ч,�������ж�Ҫ��ʾ��λ��ʦ
   --- select depname,biaogemingcheng,inputdate from [dbzhushui] where wellname='��������վˮԴ��'
  --��ȷ��֮��ɾ����wellname ���������ֵľ�����Ч��
  --delete from [DBZhuShui] where wellname not like '%[123456789]%'

��---��ѯ��zsd like �ϼ�,������У������ϢҪ�����ݱ�����һ���ķ�����ſ��Խ��в�����
  select * from [DBZhuShui] where zsd like '%��%��%' 
��---ɾ����zsd like �ϼ�,�������
��---delete from [DBZhuShui] where zsd like '%��%��%'

  
----��������wellname(���µ����������������ֿ�ͷ�ľ�����Ϊ��'��ע'+wellname+'��'���Ժ��ֿ�ͷ�ľ����ֲ���)
 --select distinct(wellname) from dbzhushui
   --��������'#','��','��'����β�ľ���Ϣ(ȥ��'#','��','��')
      update dbzhushui set wellname=replace(wellname,'��','') where wellname like '%[��]'
      update dbzhushui set wellname=replace(wellname,'#','') where wellname like '%[#]'
      update dbzhushui set wellname=replace(wellname,'��','') where wellname like '%[��]'
   --��������'��ע'��ͷ�Ĳ��־���(��ȥ��'��ע'�Ա���ͳһ����)
      update dbzhushui set wellname=replace(wellname,'��ע','') where wellname like '��ע%'
   --�����������ֿ�ͷ�ľ���('��ע'+wellname+'��')
      --select  '��ע'+rtrim(convert(nvarchar(40),[wellname]))+'��' from dbzhushui where wellname like '[123456789]%[^��]'
      --update dbzhushui set wellname='��ע'+rtrim(convert(nvarchar(40),[wellname]))+'��' where wellname like '[123456789]%[^��]'

-----�鿴������Ϣ
select count(*) ���� from dbzhushui
select count(*) ��wellname������ from dbzhushui where wellname is not null
select distinct(wellnamea) wellnameΪ�յ����� from dbzhushui where wellname is  null


update temp set name='��ע'+rtrim(convert(nvarchar(40),[name]))+'��'
select name from temp