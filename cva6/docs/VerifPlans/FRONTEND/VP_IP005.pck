(VBHT
p0
ccopy_reg
_reconstructor
p1
(cvp_pack
Ip
p2
c__builtin__
object
p3
Ntp4
Rp5
(dp6
Vprop_count
p7
I6
sVname
p8
g0
sVprop_list
p9
(dp10
sVip_num
p11
I5
sVwid_order
p12
I5
sVrfu_dict
p13
(dp14
sVrfu_list
p15
(lp16
(V000_flush
p17
g1
(cvp_pack
Prop
p18
g3
Ntp19
Rp20
(dp21
Vitem_count
p22
I1
sg8
g17
sVtag
p23
VVP_IP005_P000
p24
sVitem_list
p25
(dp26
sg12
I0
sg15
(lp27
(V000
p28
g1
(cvp_pack
Item
p29
g3
Ntp30
Rp31
(dp32
g8
V000
p33
sg23
VVP_IP005_P000_I000
p34
sVdescription
p35
VThe BTB is never flushed.
p36
sVpurpose
p37
VFRONTEND sub-system/Architecture and Modules/BHT
p38
sVverif_goals
p39
VNA\u000a\u000a[Does it make sense?]
p40
sVcoverage_loc
p41
V
p42
sVpfc
p43
I-1
sVtest_type
p44
I-1
sVcov_method
p45
I-1
sVcores
p46
I0
sVcomments
p47
g42
sVstatus
p48
g42
sVsimu_target_list
p49
(lp50
sg15
(lp51
sVrfu_list_2
p52
(lp53
sg13
(dp54
Vlock_status
p55
I0
ssbtp56
asVrfu_list_1
p57
(lp58
sg52
(lp59
sg13
(dp60
sbtp61
a(V002_table update
p62
g1
(g18
g3
Ntp63
Rp64
(dp65
g22
I1
sg8
g62
sg23
VVP_IP005_P002
p66
sg25
(dp67
sg12
I2
sg15
(lp68
(V000
p69
g1
(g29
g3
Ntp70
Rp71
(dp72
g8
V000
p73
sg23
VVP_IP005_P002_I000
p74
sg35
VWhen a branch instruction is resolved by the EXECUTE, the relative information is stored in the Branch History Table.
p75
sg37
VFRONTEND sub-system/Architecture and Modules/BHT
p76
sg39
VWhen a mis predict occurs caused by BRANCH, check that info is stored in BHT
p77
sg41
g42
sg43
I-1
sg44
I-1
sg45
I-1
sg46
I16
sg47
g42
sg48
g42
sg49
(lp78
sg15
(lp79
sg52
(lp80
sg13
(dp81
g55
I0
ssbtp82
asg57
(lp83
sg52
(lp84
sg13
(dp85
sbtp86
a(V003_saturation
p87
g1
(g18
g3
Ntp88
Rp89
(dp90
g22
I2
sg8
g87
sg23
VVP_IP005_P003
p91
sg25
(dp92
sg12
I3
sg15
(lp93
(V000
p94
g1
(g29
g3
Ntp95
Rp96
(dp97
g8
V000
p98
sg23
VVP_IP005_P003_I000
p99
sg35
VThe Branch History table is a two-bit saturation counter that takes the virtual address of the current fetched instruction by the CACHE. It states whether the current branch request should be taken or not. The two bit counter is updated by the successive execution of the current instructions as shown in the following figure.
p100
sg37
VFRONTEND sub-system/Architecture and Modules/BHT
p101
sg39
VExecute a serie of taken and not taken branch to check the saturation mechanism
p102
sg41
g42
sg43
I-1
sg44
I-1
sg45
I-1
sg46
I-1
sg47
g42
sg48
g42
sg49
(lp103
sg15
(lp104
sg52
(lp105
sg13
(dp106
g55
I0
ssbtp107
a(V001
p108
g1
(g29
g3
Ntp109
Rp110
(dp111
g8
V001
p112
sg23
VVP_IP005_P003_I001
p113
sg35
VThe Branch History table is a two-bit saturation counter that takes the virtual address of the current fetched instruction by the CACHE. It states whether the current branch request should be taken or not. The two bit counter is updated by the successive execution of the current instructions as shown in the following figure.
p114
sg37
VFRONTEND sub-system/Architecture and Modules/BHT
p115
sg39
VVerify the saturation mechnism is optimal. Modify the saturation mechanism by removing/adding one stage, and check the Coremark performance evolution
p116
sg41
g42
sg43
I-1
sg44
I-1
sg45
I-1
sg46
I16
sg47
g42
sg48
g42
sg49
(lp117
sg15
(lp118
sg52
(lp119
sg13
(dp120
g55
I0
ssbtp121
asg57
(lp122
sg52
(lp123
sg13
(dp124
sbtp125
a(V004_Table depth
p126
g1
(g18
g3
Ntp127
Rp128
(dp129
g22
I1
sg8
g126
sg23
VVP_IP005_P004
p130
sg25
(dp131
sg12
I4
sg15
(lp132
(V000
p133
g1
(g29
g3
Ntp134
Rp135
(dp136
g8
V000
p137
sg23
VVP_IP005_P004_I000
p138
sg35
VThe information is stored in a 1024 entry table.
p139
sg37
VFRONTEND sub-system/Architecture and Modules/BHT
p140
sg39
VConfirm that the best configuration for BHT entry number is 1024 by monitoring the Coremark performance and silicon footprint, the configuration without BHT is to be challenged too.
p141
sg41
g42
sg43
I-1
sg44
I-1
sg45
I-1
sg46
I16
sg47
g42
sg48
g42
sg49
(lp142
sg15
(lp143
sg52
(lp144
sg13
(dp145
g55
I0
ssbtp146
asg57
(lp147
sg52
(lp148
sg13
(dp149
sbtp150
a(V005_Debug is not intrusive
p151
g1
(g18
g3
Ntp152
Rp153
(dp154
g22
I1
sg8
g151
sg23
VVP_IP005_P005
p155
sg25
(dp156
sg12
I5
sg15
(lp157
(V000
p158
g1
(g29
g3
Ntp159
Rp160
(dp161
g8
V000
p162
sg23
VVP_IP005_P005_I000
p163
sg35
VThe BHT is not updated if processor is in debug mode.
p164
sg37
VFRONTEND sub-system/Architecture and Modules/BHT
p165
sg39
VExecute a debug session, check that the table content is not modified
p166
sg41
g42
sg43
I-1
sg44
I-1
sg45
I-1
sg46
I32
sg47
g42
sg48
g42
sg49
(lp167
sg15
(lp168
sg52
(lp169
sg13
(dp170
g55
I0
ssbtp171
asg57
(lp172
sg52
(lp173
sg13
(dp174
sbtp175
asVrfu_list_0
p176
(lp177
sg57
(lp178
sVvptool_gitrev
p179
V$Id$
p180
sbtp181
.