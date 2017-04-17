close all;
clear;
clc;
warning off; %#ok<WNOFF>

%1  2  3  4  5  6  7  8  9 10  11 12 13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28
[b1,b2,b3,s1,s2,s3,b4,b5,b6,b7,b8,b9,b10,b11,b12,s4,b13,b14, s5, s6,b15, s7,b16,b17,b18,b19,b20,b21] = ...
textread('../data/horse.txt','%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
biao = [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20,b21];
shu = [s1,s2,s3,s4,s5,s6,s7];
all =[biao,shu];

freb1=tabulate(all(:,1));
freb2=tabulate(all(:,2));
freb3=tabulate(all(:,3));
freb4=tabulate(all(:,7));
freb5=tabulate(all(:,8));
freb6=tabulate(all(:,9));
freb7=tabulate(all(:,10));
freb8=tabulate(all(:,11));
freb9=tabulate(all(:,12));
freb10=tabulate(all(:,13));
freb11=tabulate(all(:,14));
freb12=tabulate(all(:,15));
freb13=tabulate(all(:,17));
freb14=tabulate(all(:,18));
freb15=tabulate(all(:,21));
freb16=tabulate(all(:,23));
freb17=tabulate(all(:,24));
freb18=tabulate(all(:,25));
freb19=tabulate(all(:,26));
freb20=tabulate(all(:,27));
freb21=tabulate(all(:,28));

info{1,1} = 'info';
info{2,1}='s1';
info{3,1}='s2';
info{4,1}='s3';
info{5,1}='s4';
info{6,1}='s5';
info{7,1}='s6';
info{8,1}='s7';


info{1,2}='min';
info{1,3}='q1';
info{1,4}='median';
info{1,5}='mean';
info{1,6}='q3';
info{1,7}='max';
info{1,8}='NA';

name{1}='s1';
name{2}='s2';
name{3}='s3';
name{4}='s4';
name{5}='s5';
name{6}='s6';
name{7}='s7';

%给出最大、最小、均值、中位数、四分位数及缺失值的个数。
[ii,j]= find(strcmp(all, '?'));
%7个数值属性%15->7**************************
for i=1:7
    %21个标称属性%3->21**************************
    s= find(j==(i+21));
    s=ii(s,:);
    que=length(s);
    for k=1:length(all)
        sss{k,1}=all{k,i+21};
    end
    sss(s,:)=[];
    for t=1:length(sss)
        sh(t,1)=str2double(sss{t,1});
    end
    maxsh=max(sh);
    minsh=min(sh);
    meansh = mean(sh);
    mediansh=median(sh);
    q1sh=prctile(sh,25);
    q3sh=prctile(sh,75);
    info{i+1,2}=minsh;
    info{i+1,3}=q1sh;
    info{i+1,4}=mediansh;
    info{i+1,5}=meansh;
    info{i+1,6}=q3sh;
    info{i+1,7}=maxsh;
    info{i+1,8}=que;
    
    
    clear sss sh s;


end

%    将缺失部分剔除
%28个属性 18->28%*********************
%XXXXXXX->?*********************
sho = zeros(1,28);
[i,j]= find(strcmp(all, '?'));
A=[i,j];
d=[i];
tab = tabulate(A(:,2));
n=length(tab);
tab= int8(tab(:,1:2));
for i = 1:n
    sho(1,tab(i,1))= tab(i,2);
end
all1 =all;  %原始数据集
nm=all(d,:);  %存在缺失数据的数据集
all1(d,:)=[];   %已删除缺失数据后的数据集


%    用最高频率值来填补缺失值
all_fre=all;
dim=numel(all)/length(all);
for ic = 1:28
    col=all(:,ic);
    [xx,yy]=find(strcmp(col,'?'));
    col_value=[xx];
    col(col_value,:)=[];
    col_table=tabulate(col);
    col_table_double=str2double(col_table(:,2));
    [maxCount,idx] = max(col_table_double);
    for ir=1:length(all_fre)
        if (strcmp(all(ir,ic),'?'))
            all_fre(ir,ic)=col_table(idx);
        end
    end

end



%    通过属性的相关关系来填补缺失值
for ir=1:size(all1,1)
    %15->7%**************
    for ic=1:7
        %3->21%********************
        shu1(ir,ic)=str2num(all1{ir,ic+21});
    end
end

relationship=corrcoef(shu1);
[~,index]=sort(relationship,2);
index2= index;

index=index(:,6);

for ir = 1:7
    for ic=1:7
        c1=shu1(:,ir);
        c2=shu1(:,index2(ir,ic));
        c2=[ones(length(c2),1),c2];
        [b,~,~,~,~]=regress(c1,c2);
        pra{ir,ic}=b;
    end
end

all_3=all;
dim=numel(all)/length(all);
for ic = 22:28
    col=all(:,ic);
    [xx,yy]=find(strcmp(col,'?'));
    col_value=[xx];
    col(col_value,:)=[];
    for ir=1:length(all_3)
        if (strcmp(all(ir,ic),'?'))
            for iii = 6:-1:1
                if ~((strcmp(all_3{ir,21+index2(ic-21,iii)},'?'))|(isnan(all_3{ir,21+index2(ic-21,iii)})))
                    aaaa = pra{ic-21,index2(ic-21,iii)}(1,1);
                    bbbb = pra{ic-21,index2(ic-21,iii)}(2,1);                   
                    cccc = all_3{ir,21+index2(ic-21,iii)};
                    if ischar(cccc)
                        cccc = str2double(cccc);
                    end
                   all_3(ir,ic) = num2cell( aaaa + bbbb*cccc);
                    break;
                
                end
            end
            
                
        end
    end
end

% % %    通过数据对象之间的相似性来填补缺失值
% all4 = all;
% Dist=zeros(length(all),length(all1));
% for i=1:length(all)
%     for j=1:length(all1)
%         Dist(j,i)=norm(all4(i,:)-all1(j,:));
%     end
% end
% [minValue,row]=min(Dist);
% for ic = 22:28
%     col=all(:,ic);
%     [xx,yy]=find(strcmp(col,'?'));
%     col_value=[xx];
%     col(col_value,:)=[];
%     for ir=1:length(all4)
%         if (strcmp(all(ir,ic),'?'))
%             all4{ir,ic} = all1(row,ic);            
%         end
%     end
% end



data1 = all1;
data2 = all_fre;
data3 = all_3;
data4 = all4;
save ('data1.mat','data1');
save ('data2.mat','data2');
save ('data3.mat','data3');
save ('data4.mat','data4');
all1 = str2double(all1);
all_fre = str2double(all_fre);
all_3 =str2double(all_3);
all_4 =str2double(all_4);
for i = 1:7
    
    fig=figure();
  hist(all1(:,i+21));   
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/hist_',name{i},'111.jpg']);
  fig= figure();
  qqplot(all1(:,i+21));
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/qq_',name{i},'111.jpg']);


    fig= figure();
    boxplot(all1(:,i+21));
    ylabel(name{i})
    saveas(fig,['./figure/box_',name{i},'111.jpg']); 
    
    
    fig=figure();
  hist(all_fre(:,i+21));   
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/hist_',name{i},'222.jpg']);
  fig= figure();
  qqplot(all_fre(:,i+21));
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/qq_',name{i},'222.jpg']);


    fig= figure();
    boxplot(all_fre(:,i+21));
    ylabel(name{i})
    saveas(fig,['./figure/box_',name{i},'222.jpg']); 
    
    
    
  fig=figure();
  hist(all_3(:,i+21));   
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/hist_',name{i},'333.jpg']);
  fig= figure();
  qqplot(all_3(:,i+21));
  xlabel(name{i});
  ylabel('Value');
  saveas(fig,['./figure/qq_',name{i},'333.jpg']);


    fig= figure();
    boxplot(all_3(:,i+21));
    ylabel(name{i})
    saveas(fig,['./figure/box_',name{i},'333.jpg']);   
    
    
 
end



