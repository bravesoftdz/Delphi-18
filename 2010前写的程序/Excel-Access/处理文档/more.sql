
use zmm
select wellname,depname,count(distinct(depname)) from [tWellDayProd20100101-0729]  group by wellname,depname having count(distinct(depname))>=2
 
-----��ѯ������һ���������ϵľ���Ϣ(Һ����Ϣ)
select wellname,depname,biaogemingcheng,inputdate 
 from [tWellDayProd20100101-0729] 
 where wellname in
   (
select wellname
 from [tWellDayProd20100101-0729]
 group by wellname
 having count(distinct(depname))>=2
 --order by wellname
)
group by depname,wellname,inputdate,biaogemingcheng
order by wellname

-----��ѯ������һ���������ϵľ�(Һ����Ϣ)
select wellname
 from [WellDayProd20100730-20100820]
 group by wellname
 having count(distinct(depname))>=2
 order by wellname

----�ͷ�ׯ�����в���¼������(Ҫ����ʵ�������ѯ)
select count(*) 
 from [tWellDayProd20100101-0729]
 where depname='�ͷ�ׯ���Ͷ�'
    and biaogemingcheng<>'���Ͷ���������'
delete from [tWellDayProd20100101-0729] where depname='�ͷ�ׯ���Ͷ�' and biaogemingcheng<>'���Ͷ���������'

