----�Զ���Һ�����ݵ�����
---------------------------------------
----�ڡ�DR����2010819������������-------
----            ����ʾ��λ��ʦ   -------
----    �밴˳��ִ��,�������Ը� -------
---------------------------------------
use zmm
select distinct(inputdate) from [welldayprod] order by inputdate

--------ɾ����Ч����Ϣ��
��--------wellnameΪ�յ��У���wellnamea��ֵ��ֵ��wellname(�����˽׶λ��wellname����������)
    update [WellDayProd] set wellname=wellnamea where wellname is null or ltrim(wellname)=''
  --------�������Ϊ�յ��У�wellname��
    delete  from [WellDayProd] where wellname is null or ltrim(wellname)=''
��--------����wellnamea ���������ֵ���
     -----������ĺϼ���Ϣ����excel�г��֡���xx���顱����Ч�ϼ���Ϣ��
     ---select wellname,wellnamea from [WellDayProd] where wellnamea like '%��%��%' or wellname like '%��%��%'
     ---delete from [WellDayProd] where wellnamea like '%��%��%' or wellname like '%��%��%'
���� -----��ѯ���������ֵ���(wellnamea)
     select wellname,wellnamea,depname,biaogemingcheng,inputdate from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' 
     select distinct(wellnamea) from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' 
     select * from [WellDayProd] where wellnamea='�¾�' 
  �� -----ɾ����wellnamea ���������ֵ���(����ȷ������Ч��ϢҪ���λ��ʦ��ʾ)
  �� --delete from [WellDayProd] where wellnamea<>'' and wellnamea not like '%[123456789]%' and wellnamea<>
�� -------����wellname ���������ֵ���
���� -----��ѯ���������ֵ���(wellname)
     select wellname,wellnamea,depname,biaogemingcheng,inputdate from [WellDayProd] where  wellname not like '%[123456789]%'
     select distinct(wellname) from [WellDayProd] where  wellname not like '%[123456789]%'
  �� -----ɾ����wellname ���������ֵ���(����ȷ������Ч��ϢҪ���λ��ʦ��ʾ)
  �� --delete from [WellDayProd] where  wellname not like '%[123456789]%'

select * from welldayprod 
--where wellname not like '��%'
----��������wellname(���µ�����������Һ�����������ֿ�ͷ�ľ�����Ϊ��'��'+wellname+'��'���Ժ��ֿ�ͷ�ľ����ֲ���)
 --select distinct(wellname) from [WellDayProd]
   --��������'#','��','��'����β�ľ���Ϣ(ȥ��'#','��','��')
      update [WellDayProd] set wellname=replace(wellname,'��','') where wellname like '%[��]%'
      update [WellDayProd] set wellname=replace(wellname,'#','') where wellname like '%[#]%'
      update [WellDayProd] set wellname=replace(wellname,'��','') where wellname like '%[��]%'
   --��������'��'��ͷ�Ĳ��־���(��ȥ��'��'�Ա���ͳһ����)
      update [WellDayProd] set wellname=replace(wellname,'��','') where wellname like '��%'
   --�����������ֿ�ͷ�ľ���('��'+wellname+'��')
      --select '��'+rtrim(convert(nvarchar(40),[wellname]))+'��' from [WellDayProd] where wellname like '[123456789]%[^��]'
      update [WellDayProd] set wellname='��'+rtrim(convert(nvarchar(40),[wellname]))+'��' where wellname  like '[123456789]%[^��]'

select wellname,depname,inputdate,biaogemingcheng from [WellDayProd]

alter trigger Processother on temp
 instead of  insert
 as
begin 
  declare @OldWellName  nvarchar(37)
  select @OldWellName=name from inserted
  if @oldwellname='������'
  print @oldwellname
end;

insert into temp(name) values('������')

select * from temp
alter table temp add id2 int identity(1,1) 