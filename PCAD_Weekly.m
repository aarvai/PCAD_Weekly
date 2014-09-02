function [maneuvers]=PCAD_Weekly(sd,ed)

% runs PCAD Weekly plot generation, data collection and archives old directoies
%
% SYNTAX:  PCAD_Weekly(yyyyddd,YYYYDDD) where yyyyddd=startday, YYYYDDD=end day
%
%           generally run for 45 days to provide context in plots 

addpath('/home/pcad/PCAD_Weekly')
tstart=time(sd);
tstop=time(ed);
ltt_root='/home/pcad/AXAFUSER/ltt/';

cd /home/pcad/PCAD_Weekly;

dn=['Weekly_' num2str(sd) '_' num2str(ed)];

mkdir(dn);

cd(dn);


temp=LTTquery([ltt_root 'A_1SHOT.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_ATTITUDE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,4)
close all
clear temp

temp=LTTquery([ltt_root 'A_A_CONV_VOLTAGE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,4)
close all
clear temp


temp=LTTquery([ltt_root 'A_GYRO_BIAS.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,3)
close all
clear temp


temp=LTTquery([ltt_root 'A_HW_ERR.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_IRU-2.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_PNT_CTRL_STAB.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,2)
close all
clear temp

temp=LTTquery([ltt_root 'A_RW_CURRENT_TEMP.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp

temp=LTTquery([ltt_root 'A_RW_SPEED.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp

temp=LTTquery([ltt_root 'A_SYSMOM.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,3)
close all
clear temp

temp=LTTquery([ltt_root 'A_WDE_CONV_VOLTAGE.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,6)
close all
clear temp

temp=LTTquery([ltt_root 'P_LINES.ltt'],tstart,tstop,'keep dat');
LTTplot(temp,4)
close all
clear temp

temp=LTTquery([ltt_root 'P_MUPS.ltt'],tstart,tstop,'keep dat');
if min(temp(1).data.min) < 276
    msgbox('Tank Pressure w/in 1 psia of caution low of 275.  Update limit soon.')
end
LTTplot(temp,4)
close all
clear temp

% update plots for web page
system('cp *.png /share/FOT/engineering/pcad/WeeklyPlots');


cd ..


% get this week's drag torque data
UpdateDragTorqueData(tstop)

% update oneshot data
cd /home/pcad/matlab/1_SHOT
addpath(pwd)
cd ManeuverData
maneuvers=OneShots(ed-10,ed)

% archive directories that haven't been used in 30 days
cd /home/pcad/PCAD_Weekly
Archive_Weekly


