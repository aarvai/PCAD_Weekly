function UpdateDragTorqueData(tstop)

% fetches drag torque data
% run from PCAD_Weekly
% checks time of last data point and fetches data from that time to the end
% of the week called by PCAD_Weekly
% data used to generate quarterly drag torque plots


cd /home/pcad/Investigations/drag_torque_study

system('cp rw1.mat Archive/old_rw1.mat')  ; % make a backup copy just incase...
load rw1 ;  % get existing data

new_rw1=gretafetch2_0('DRAG_TORQUE_1.dec',rw1.time(end),tstop+86400) ; % fetch new data, 
%   add a day since ltt includes last day requested, but gretafetch does not
rw1=gretamerge(rw1,new_rw1);   % merge into one structure
save rw1 rw1  % save new structure
clear rw1
clear new_rw1  % clear to avoid any memory problems with long fetches

system('cp rw2.mat Archive/old_rw2.mat');
load rw2;
new_rw2=gretafetch2_0('DRAG_TORQUE_2.dec',rw2.time(end),tstop+86400);
rw2=gretamerge(rw2,new_rw2);
save rw2 rw2;
clear rw2
clear new_rw2

system('cp rw3.mat Archive/old_rw3.mat');
load rw3;
new_rw3=gretafetch2_0('DRAG_TORQUE_3.dec',rw3.time(end),tstop+86400);
rw3=gretamerge(rw3,new_rw3);
save rw3 rw3;
clear rw3
clear new_rw3

system('cp rw4.mat Archive/old_rw4.mat');
load rw4;
new_rw4=gretafetch2_0('DRAG_TORQUE_4.dec',rw4.time(end),tstop+86400);
rw4=gretamerge(rw4,new_rw4);
save rw4 rw4;
clear rw4
clear new_rw4

system('cp rw5.mat Archive/old_rw5.mat');
load rw5;
new_rw5=gretafetch2_0('DRAG_TORQUE_5.dec',rw5.time(end),tstop+86400);
rw5=gretamerge(rw5,new_rw5);
save rw5 rw5;
clear rw5;
clear new_rw5;

system('cp rw6.mat Archive/old_rw6.mat');
load rw6;
new_rw6=gretafetch2_0('DRAG_TORQUE_6.dec',rw6.time(end),tstop+86400);
rw6=gretamerge(rw6,new_rw6);
save rw6 rw6;
clear rw6;
clear new_rw6;