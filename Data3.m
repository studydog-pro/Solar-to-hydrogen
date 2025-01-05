si = [];

si.eta_de=2;
si.lamuda_CC=0.269;%碳捕集能耗Mwh/t
si.eta_cc=0.85;%碳捕集效率
% si.eta_H2=0.75;
si.eta_H2min=0;si.eta_H2max=1;%产氢效率最大最小值
si.eta=39.65;%kwh/kg
si.eta_MR=0.75;%MR效率
si.aerfa=0.1;%掺氢比10%
si.daita=2;%甲烷和氢气转换系数
si.rou_H2=39.062;%氢气密度（70MPa，39.062kg/m3）
si.rou_CH4=312.496;%甲烷密度
si.rou_mix=285.1526;%混合密度（10%）
si.M_mix=14.436;%以掺氢比（10%）的混合摩尔质量
si.lamuda_CH4=0.8;%甲烷燃烧反应生成物计量数
si.lamuda_H2=0.9;%氢气燃烧反应生成物计量数 
si.fai_CH4=0.888;%甲烷摩尔分数转换系数
si.fai_H2=0.112;%氢气摩尔分数转换系数
si.T_in=640;%HT进气口燃烧温度K
si.T_comCH4=2223;%甲烷稳态燃烧温度K
si.T_comH2=2293;%氢气稳态燃烧温度K
si.HeatCH4=39.8;%甲烷热值
si.HeatH2=12.75;%氢气热值
si.Linepack0=100;%管存初值
si.aerfa_nv_CH4=1;%甲烷体积换算系数
si.aerfa_nv_H2=1;%氢气体积换算系数
si.N_in_CH4=0.9;%甲烷初始摩尔分数
si.N_in_H2=0.1;%氢气初始摩尔分数
si.a=0.9;%燃煤机组单位出力产生二氧化碳量1t/mw
si.daita_e=0.2;%碳配额系数t/MW
si.lamuda=0.2;%碳补偿系数
si.beta=39.3;%碳交易价格
si.l=20;%碳交易区间长度20t
si.e=0.25;%碳交易价格增长幅度

si.M_air=28.9634;si.M_H2=2.01588;si.M_CH4=16.043;%摩尔质量
si.absorb=0.95;
si.tao=0.03;%GC 耗气率
si.fp=2.50;%天然气燃料成本系数3.5/2     CCS:1.7  MR:0.3
si.HTcost=15;%CHP的燃料成本系数  1.5
si.CCScost=20;%CCS燃料成本系数54元/MW
si.ELcost_1=10;%10  5
si.MRcost=0.50;
si.NumEn=33;%节点数
si.NumEl=32;%ieee 33节点系统支路数
si.Horizon=24;%总调度时段数

si.NumGn=20;si.NumGl=19;si.NumGC=3;si.NumGW=4;

% si.inonoff=[0 0 1]';%initial state of thermal units
% si.minup=[3 3 3];
% si.mindown=si.minup;
si.stcost=[280 280 280];si.sdcost=[3200 3200 3200];
si.idle=1;
si.on=0;
si.standby=0;
si.mindown=4;

GLD=xlsread('Gas.xlsx','Gas load','A2:D21');
GWD=xlsread('Gas.xlsx','Gas well','A2:E5');
si.TPD=xlsread('Gas.xlsx','Pipeline','A2:E17');
GCD=xlsread('Gas.xlsx','Compressor','A2:F4');

si.GWlocat=GWD(:,2);%气源安装位置
si.Gflowmax=si.TPD(:,5);%气支路潮流限制
si.pimin=GLD(:,4);si.pimax=GLD(:,3);%气节点压力最大最小
si.GCmax=GCD(:,6);si.C_in=GCD(:,2);si.C_out=GCD(:,3);si.C_ratiomin=GCD(:,4);si.C_ratiomax=GCD(:,5);%压缩机相关参数
si.GWmin=zeros(si.NumGn,1);si.GWmin(GWD(:,2))=0;%气源最大最小出力
si.GWmax=zeros(si.NumGn,1);si.GWmax(GWD(:,2))=GWD(:,3);
%% 电气负荷曲线

% GLrate=[1.0 1.0 0.9 0.9 1.0 1.0 1.0 0.7 0.7 0.7 0.8 0.7 1.0 1.0 0.9 0.9 1.0 1.0 1.0 0.7 0.7 0.7 0.8 1.0];%气负荷典型曲线
GLrate=[0.642 0.652 0.642 0.631 0.668 0.722 0.802 0.909 0.989 0.995 1 0.936 0.882 0.882 0.963 0.952 0.936 0.920 0.882 0.856 0.802 0.775 0.78 0.742];
% GLrate=[1.0 1.0 0.9 0.9 1.0 1.0 1.0 0.7	0.7	0.7	0.8	0.7	0.7 0.8 0.7 0.7 0.7 1.0 1.0 1.0 0.9 0.9 1.0 1.0];
GL=zeros(si.NumGn,1);
GL(GLD(:,1))=GLD(:,2)*0.5;%0.5
for t=1:si.Horizon
    si.GL(:,t)=GL'*GLrate(t);%实际气负荷曲线
end

%%
si.Wc=100;%弃风惩罚成本系数
si.K=0.75;%与功率因数有关，表示发电机组发出的有功和无功间的关系

si.etaEB=2;%电锅炉的电热转化比
si.cb=[3.20E-05 3.00E-05 3.00E-05 2.90E-05 2.80E-05 3.30E-05 4.20E-05 4.50E-05 4.50E-05 4.20E-05 4.00E-05 3.90E-05 3.80E-05 3.70E-05 4.70E-05 4.80E-05 4.90E-05 4.70E-05 5.90E-05 4.70E-05 4.60E-05 3.80E-05 3.80E-05 3.70E-05]*14e5;%日前电力市场购电价2500
si.cs=0.3*si.cb;%日前电力市场售电价

si.PTiemax=1000;%配电网与上级电网通过根节点（0号节点）交互的有功功率限值
si.QTiemax=1000;%配电网与上级电网通过根节点（0号节点）交互的无功功率限值

rate=[0.68 0.64 0.62 0.60 0.61 0.63 0.68 0.70 0.73 0.81 0.89 0.92 0.95 0.95 0.97 0.95 0.93 0.91 0.89 0.90 0.93 0.91 0.86 0.86];%调度周期内有功/无功电负荷的曲线形状
% rate=[0.58 0.60 0.60 0.60 0.61 0.63 0.68 0.70 0.73 0.81 0.89 0.92 0.95 0.95 0.97 0.95 0.93 0.91 0.89 0.90 0.93 0.91 0.86 0.86];%调度周期内有功/无功电负荷的曲线形状
% rate=[0.642 0.652 0.642 0.631 0.668 0.722 0.802 0.909 0.989 0.995 1 0.936 0.882 0.882 0.963 0.952 0.936 0.920 0.882 0.856 0.802 0.775 0.78 0.742];;
Total_P = rate*1500;%kW 有功电负荷 2600
Total_Q = rate*1200;%kVar 无功电负荷
si.Total_P=Total_P;si.Total_Q=Total_Q;
% \rho(j): 节点j的父节点（可以理解为节点j是儿子，父节点是儿子节点j前面的一个节点）
si.rho = [0; 0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 1; 18; 19; 20; 2; 22; 23; 5; 25; 26; 27; 28; 29; 30; 31]+1;
% 节点j
j = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32];
% ieee 33配网支路参数
% from_bus   to_bus   r    x
si.Network=[
    1	2	0.0922	0.0407
    2	3	0.493	0.2511
    3	4	0.366	0.1864
    4	5	0.3811	0.1941
    5	6	0.819	0.707
    6	7	0.1872	0.6188
    7	8	0.7144	0.2351
    8	9	1.03	0.74
    9	10	1.044	0.74
    10	11	0.1966	0.065
    11	12	0.3744	0.1238
    12	13	1.468	1.155
    13	14	0.5416	0.7129
    14	15	0.591	0.526
    15	16	0.7463	0.545
    16	17	1.289	1.721
    17	18	0.732	0.574
    2	19	0.164	0.1565
    19	20	1.5042	1.3554
    20	21	0.4095	0.4784
    21	22	0.7089	0.9373
    3	23	0.4512	0.3083
    23	24	0.898	0.7091
    24	25	0.896	0.7011
    6	26	0.203	0.1034
    26	27	0.2842	0.1447
    27	28	1.059	0.9337
    28	29	0.8042	0.7006
    29	30	0.5075	0.2585
    30	31	0.9744	0.963
    31	32	0.3105	0.3619
    32	33	0.341	0.5362];
% 有功负荷比例 无功负荷比例 节点号
Demand=[0	0	1
    0.0269179	0.026086957	2
    0.02422611	0.017391304	3
    0.03230148	0.034782609	4
    0.01615074	0.013043478	5
    0.01615074	0.008695652	6
    0.053835801	0.043478261	7
    0.053835801	0.043478261	8
    0.01615074	0.008695652	9
    0.01615074	0.008695652	10
    0.012113055	0.013043478	11
    0.01615074	0.015217391	12
    0.01615074	0.015217391	13
    0.03230148	0.034782609	14
    0.01615074	0.004347826	15
    0.01615074	0.008695652	16
    0.01615074	0.008695652	17
    0.02422611	0.017391304	18
    0.02422611	0.017391304	19
    0.02422611	0.017391304	20
    0.02422611	0.017391304	21
    0.02422611	0.017391304	22
    0.02422611	0.02173913	23
    0.113055182	0.086956522	24
    0.113055182	0.086956522	25
    0.01615074	0.010869565	26
    0.01615074	0.010869565	27
    0.01615074	0.008695652	28
    0.03230148	0.030434783	29
    0.053835801	0.260869565	30
    0.040376851	0.030434783	31
    0.056527591	0.043478261	32
    0.01615074	0.017391304	33];
si.NumLoad=33;
% SVC最小出力   SVC最大出力  SVC所在配网的节点位置
SVCDATA=[
    -600  600  5; %2
    -600  600 19; %2
    -600  600  26; %3
    ];
si.SVClocat=SVCDATA(:,3);
si.SVCmin=zeros(si.NumEn,1);si.SVCmin(si.SVClocat)=SVCDATA(:,1);
si.SVCmax=zeros(si.NumEn,1);si.SVCmax(si.SVClocat)=SVCDATA(:,2);
% 风机最小出力  风机额定容量（没用到）  风机所在配网的节点位置
PVDATA=[
    0    600 7;
    0    600 25;
    0    600 28;
    ];
si.PVlocat=PVDATA(:,3);%风机机所在节点位置
si.NumPV=3;

%Number 	Bus at the power system 	Gmin	 Gmax
HT=[
1	2	2	0	5000
% 2	7	7	0	10000
% 3	28	11	0	10000
];
si.GHTmin=0;si.GHTmax=5000;
si.NumHT=size(HT,1);
si.HTlocat_E=HT(:,2);si.HTlocat_G=HT(:,3);
si.VHTmin=zeros(si.NumGn,1);si.VHTmin(si.HTlocat_G)=HT(:,4);
si.VHTmax=zeros(si.NumGn,1);si.VHTmax(si.HTlocat_G)=HT(:,5);
si.PHTmin=zeros(si.NumEn,1);si.PHTmin(si.HTlocat_E)=0;
si.PHTmax=zeros(si.NumEn,1);si.PHTmax(si.HTlocat_E)=600;%HT的数量，在电网和气网中的位置,最大耗气量,最大最小功率（取值足够大）
si.QHTmax = HT(:,5)*0.1;%HT无功最大出力
si.QHTmin = 0;%HT无功最小出力


%Number 	Bus at the power system 	Node at the gas system 	Conversion coefficient (kcf/MW)	P2G min	P2G max
P2G=[
1	7	4	1.5000	0	150
2	25	10	1.2000	0	150
3	28	11	1.2000	0	150
];
si.NumP2G=3;
si.P2Glocat_E=P2G(:,2);si.P2Glocat_G=P2G(:,3);
si.P2Gmin=zeros(si.NumEn,1);si.P2Gmin(si.P2Glocat_E)=P2G(:,5);
si.P2Gmax=zeros(si.NumEn,1);si.P2Gmax(si.P2Glocat_E)=P2G(:,6);
si.P2G_Gmax=zeros(si.NumGn,1);si.P2G_Gmax(si.P2Glocat_G)=P2G(:,6);%P2G的数量，在电网和气网中的位置,最大功率

si.P2G_min=zeros(si.NumP2G,1);si.P2G_min=P2G(:,5);
si.P2G_max=zeros(si.NumP2G,1);si.P2G_max=P2G(:,6);
%Number 	Bus at the power system 	Node at the gas system 	U_Elmin   U_Elmax
T_EL=[
1	7	4	300   360   0   10   0    1e5
2	25	10	300   360   0   10   0    1e5
3	28	11	300   360   0   10   0    1e5
];
si.T_ELmin=zeros(si.NumEn,1);si.T_ELmin(si.P2Glocat_E)=T_EL(:,4);
si.T_ELmax=zeros(si.NumEn,1);si.T_ELmax(si.P2Glocat_E)=T_EL(:,5);
si.U_ELmin=zeros(si.NumEn,1);si.U_ELmin(si.P2Glocat_E)=T_EL(:,6);
si.U_ELmax=zeros(si.NumEn,1);si.U_ELmax(si.P2Glocat_E)=T_EL(:,7);
si.I_ELmin=zeros(si.NumEn,1);si.I_ELmin(si.P2Glocat_E)=T_EL(:,8);
si.I_ELmax=zeros(si.NumEn,1);si.I_ELmax(si.P2Glocat_E)=T_EL(:,9);

%Number 	Bus at the power system 	Node at the gas system 	WMR min	WMR max
MR=[
1	7	4	0	5000   0    100
2	25	10	0	5000   0    100
2	28	11	0	5000   0    100
];
si.NumMR=3;
si.MRlocat_E=MR(:,2);si.MRlocat_G=MR(:,3);
si.GHMRmin=zeros(si.NumGn,1);si.GHMRmin(si.MRlocat_G)=MR(:,4);
si.GHMRmax=zeros(si.NumGn,1);si.GHMRmax(si.MRlocat_G)=MR(:,5);
si.PMRmin=zeros(si.NumEn,1);si.PMRmin(si.MRlocat_E)=MR(:,6);
si.PMRmax=zeros(si.NumEn,1);si.PMRmax(si.MRlocat_E)=MR(:,7);%MR的数量，在电网和气网中的位置，最大耗气量

% 储氢罐=数量     位置      最小容量     最大容量（m3）
H_storage=[
    1    4  4000  20000 0 5000; 
    2    10  4000  20000 0 5000; 
    2    11  4000  20000 0 5000;
    ];
 si.NumHys=2;
 si.Hyslocat=H_storage(:,2);
 si.Hysmin=zeros(si.NumGn,1); si.Hysmin(si.Hyslocat)=H_storage(:,3);
 si.Hysmax=zeros(si.NumGn,1); si.Hysmax(si.Hyslocat)=H_storage(:,4);
 si.GHysmin=zeros(si.NumGn,1); si.GHysmin(si.Hyslocat)=H_storage(:,5);
 si.GHysmax=zeros(si.NumGn,1); si.GHysmax(si.Hyslocat)=H_storage(:,6);%Hys的数量，位置，最大，最小储气量   %%（最大最小流量）

% ES数量  在配网位置  最小放电  最大放电  最小容量  最大容量
ES=[
    1  15   0  200  0  1000  ; %2
    2  10  0  200  0  1000 ; %2
    3  27  0  200  0  1000 ; %3
    4  7  0  200  0  1000 ; %3
    ];
si.NumES=4;si.etaES=0.95;
si.ESlocat=ES(:,2);
si.PESmin=zeros(si.NumEn,1);si.PESmin(si.ESlocat)=ES(:,3);
si.PESmax=zeros(si.NumEn,1);si.PESmax(si.ESlocat)=ES(:,4);
si.Emin=zeros(si.NumEn,1);si.Emin(si.ESlocat)=ES(:,5);
si.Emax=zeros(si.NumEn,1);si.Emax(si.ESlocat)=ES(:,6);

%Number 	Bus at the power system 	CCS min	  CCS max
CCS=[
1	2	0	100
% 2	7	0	100
% 3	28	0	100
];
si.NumCCS=1;si.CCSlocat=CCS(:,2);
si.CCSmin=zeros(si.NumEn,1);
si.CCSmax=zeros(si.NumEn,1);si.CCSmax(si.CCSlocat)=CCS(:,4);%CCS的数量，在电网中的位置,最大功率

%Number 	Bus at the power system 	V min	  V max
rich=[
1	2	0	5000  
% 2	7	0	5000
% 3	28	0	5000
];
si.Numrich=1;si.richlocat=rich(:,2);
si.richmin=zeros(si.NumEn,1);si.richmin(si.richlocat)=rich(:,3);
si.richmax=zeros(si.NumEn,1);si.richmax(si.richlocat)=rich(:,4);

poor=[
1	2	0	5000
% 2	7	0	5000
% 3	28	0	5000
];
si.Numpoor=1;si.poorlocat=poor(:,2);
si.poormin=zeros(si.NumEn,1);si.poormin(si.richlocat)=poor(:,3);
si.poormax=zeros(si.NumEn,1);si.poormax(si.poorlocat)=poor(:,4);
si.co2=0.1;%富液罐co2浓度


si.Nunits=size(HT,1);%微燃机数量(获取行数)
% si.PV=[5 5 6 7 8 9 100 101 140 170 160 170
%     5 5 6 7 8 9 100 101 140 170 160 170
%     5 5 6 7 8 9 100 101 140 170 160 170]*2;
% si.PV=[17 15 17 11 8 8 13 10 8 9 8 9 9 8 9 8 11 12 15 13 15 19 11 12;
%     17 15 17 11 8 8 13 10 8 9 8 9 9 8 9 8 11 12 15 13 15 19 11 12;
%     17 15 17 11 8 8 13 10 8 9 8 9 9 8 9 8 11 12 15 13 15 19 11 12]*30;%调度周期内风机出力曲线
% si.PV=[5 5 6 7 8 9 100 101 140 200 30 40 220 200 160 140 110 80 60 50 4 3 4 5
%     5 5 6 7 8 9 100 101 140 200 30 40 220 200 160 140 110 80 60 50 4 3 4 5
%     5 5 6 7 8 9 100 101 140 200 30 40 220 200 160 140 110 80 60 50 4 3 4 5]*2;%阴天  调度周期内光伏出力曲线
si.PV=[5 5 5 5 5 5 100 101 140 200 210 220 220 200 200 190 180 80 60 50 4 3 4 5
    5 5 5 5 5 5 100 101 140 200 210 220 220 200 200 190 180 80 60 50 4 3 4 5
    5 5 5 5 5 5 100 101 140 200 210 220 220 200 200 190 180 80 60 50 4 3 4 5]*2;%调度周期内光伏出力曲线
si.A=zeros(si.NumEn,si.NumEn);
for i=1:si.NumEl
    si.A(si.Network(i,1),si.Network(i,2))=1;%支路-节点 矩阵
end

for t=1:si.Horizon
    si.PL(:,t) = Total_P(t) * Demand(:,1);%调度周期内每个节点的有功负荷
    si.QL(:,t) = Total_Q(t) * Demand(:,2);%调度周期内每个节点的无功负荷
end
 
si.Vmax = 12.66*1.1;% 节点电压最大值
si.Vmin = 12.66*0.9;% 节点电压最小值

%% 节点热值

si.Ratiomin=0.03;si.Ratiomax=0.30;%掺氢比上下限
si.H_nodemin=(1-si.Ratiomax)*si.HeatCH4+si.Ratiomax*si.HeatH2;si.H_nodemax=(1-si.Ratiomin)*si.HeatCH4+si.Ratiomin*si.HeatH2;%节点热值上下限

%% PV data
% G=[0	0	0	0	0	0	0	258.819045102521	500.000000000000	707.106781186547	866.025403784439	965.925826289068	1000	965.925826289068	866.025403784439	707.106781186548	500.000000000000	258.819045102521	180	80	0	0	0];
% I_mpp=[0.1	0.1	0.1	0.1	0.2	0.3	0.8	2.61407235553546	5.05000000000000	7.14177848998413	8.74685657822283	9.75585084551959	10.1000000000000	9.75585084551959	8.74685657822283	7.14177848998413	7.05000000000000	2.61407235553546	1.23689326713883e-15	0.1	0.1	0.1	0.1	0.1];
% V_mpp=[38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	39.0129846837212	39.2040000000000	39.3680285706998	39.4938921197973	39.5730132544209	39.6000000000000	39.5730132544209	39.4938921197973	39.3680285706998	39.2040000000000	39.0129846837212	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000	38.8080000000000];
% si.PV=[I_mpp.*V_mpp;
%     I_mpp.*V_mpp;
%     I_mpp.*V_mpp];