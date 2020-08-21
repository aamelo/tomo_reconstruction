% This script will run inside the folder containing motioncorrected
% micrographs from scipion, relion or any other software. In order to
% correctly use this script, files should be labeled as follow:
%         
%       Prefix_TSNumber_MicNumber_TiltAngle_Suffix
% 
% Example:amelo_20200819_19_0012_33.0_aligned_mic.mrc
% where Prefix = amelo_20200819_
%       TSNumber = 19
%       MicNumber = 0012
%       TiltAngle = 33.0
%       Suffix = _aligned_mic.mrc
% 
% With this script it won't matter how many micrographs one will have in
% the same folder. For better organization, I would recommend to create a
% softlink of .mrc files and then work on that folder.  
% 
% This script will separate the micrographs according to the TSNumber,
% count how many micrograph each tiltseries has, organize the micrographs
% from lowest angle to the highest angle, e.g. from -60 to +60, and output
% the file list for creating the stack using IMOD's newstack. It will also
% output if your stacks are incomplete, complete or have more micrographs
% than they should have. 
% 
% Example:
%
% create_tiltseriesWrapper(prefix,suffix,min_angle,max_angle,increment);
%
% create_tiltseriesWrapper('amelo_20200819_','_aligned_mic_DW.mrc',-48,48,3);
% 
% 
% 
% 
% 
% 
%

function  create_TS_stack_Wrapper(mic_prefix,mic_suffix,min_angle,max_angle,increment,varargin)



%create_tiltseriesWrapper(mic_prefix,mic_suffix,min_angle,max_angle,increment,varargin)

% input parser

% p = inputParser();
% addParameter(p,'min_angle',-60);
% addParameter(p,'max_angle',+60);
% addParameter(p,'increment',3);
% parse(p,'min_angle',-60);
% parse(p,'max_angle',+60);
% parse(p,'increment',3);
% q=p.Results(varagin);


%Asses how many micrographs your tiltseries should have.
ts_angles=(min_angle:increment:max_angle);
ts_angles=transpose(ts_angles);
complete_ts_number=size(ts_angles);

disp(['################################################################# ']);

disp(['A complete tiltseries will have ' num2str(complete_ts_number(1,1)) ' micrographs.']);

disp(['################################################################# ']);

%STEP 1 - Generating intial tables
files=dir(['*' mic_suffix]); %Generate a struct file with a list of file names
T = struct2table(files); %Convert structure array to table
file_list=T(:,1); %Isolate only the column containing the filename
fileChar=table2struct(file_list); %convert table to struct
tilt=strings(1,1);
stackNumber=strings(1,1);
filename=strings(1,1);

for i=1:length(files);
    filename(i,1)=files(i).name;
    splitFilename=split(filename,'_');
    %tilt(i,1)=fileChar(i).name(49:end);
    %stackNumber(i,1)=fileChar(i).name(41:42);
end

tilt=splitFilename(:,8);
stackNumber=splitFilename(:,6);
stacks=unique(stackNumber);

%STEP 2 - Organize micrographs and output list file
list_of_files_Table=table();
listName=cell(1,length(stacks));
c=1;
for i=1:length(stacks)
    list_of_files=dir([mic_prefix + stacks(c,1) + '_*' + mic_suffix]);
    list_of_files_Table=struct2table(list_of_files);
    listName{c}=list_of_files_Table.name;
    
    %All stacks in one struct array
    all_stacks.stack{c}=struct();
    all_stacks.stack{c}.tilt=strings(1,1);
    all_stacks.stack{c}.micNumber=strings(1,1);
    all_stacks.stack{c}.filename=strings(1,1);
    
    B=split(listName{1,c},'_',2); % 2 is the dimension of the array so all tables are aplit equally
    SizeB=size(B);
    all_stacks.stack{1,c}.tilt=cellfun(@str2num,B(:,8));
    all_stacks.stack{1,c}.micNumber=cellfun(@str2num,(B(:,7)));
    all_stacks.stack{1,c}.filename=listName{1,c};
    Number_of_micrographs=size(all_stacks.stack{1,c}.micNumber);
   
    if Number_of_micrographs(1,1) > 20
        all_stacks.stack{1,c}.Ordering=table();
        all_stacks.stack{1,c}.Ordering(:,1)=array2table(all_stacks.stack{1,c}.micNumber);
        all_stacks.stack{1,c}.Ordering(:,2)=array2table(all_stacks.stack{1,c}.tilt);
        all_stacks.stack{1,c}.Ordering(:,3)=all_stacks.stack{1,c}.filename;
        sorted_micrographs=sortrows(all_stacks.stack{1,c}.Ordering,2); %Sort rows based on tilt column from -48 to +48
        
        % generate input/output filenames
        %inputfile  = stackFileName;
        
        %This part will output the size of the stack
        
        stackname=stacks(c,1);
        disp(['Tiltseries_number=' num2str(stackname)]);
        
        size_of_stack=max(table2array(all_stacks.stack{1,c}.Ordering(:,1)));
        disp(['Number of micrographs in tiltseries of number ' num2str(stackname) ' is ' num2str(size_of_stack)]);
        
        if size_of_stack == complete_ts_number(1,1); %bidirectional tiltseries from -48 to +48 in 3 degrees increment
            disp(['Tiltseries number ' num2str(stackname) ' is complete!']);
            %disp([' ']);
        elseif size_of_stack < complete_ts_number(1,1); 
            disp(['Tiltseries number ' num2str(stackname) ' is incomplete!']);
            %disp([' ']);
        else size_of_stack > complete_ts_number(1,1);
            disp(['Tiltseries number ' num2str(stackname) ' has more micrographs than it should. Check for duplicates.']);
            %disp([' ']);
        end
        
        
        %outputfile = ['ts_' stackname '.mrc'];
        micrograph_names=table2array(sorted_micrographs(:,3));
        
        % generate text file with micrograph names
         fileID = fopen('list_ts_' + stackname + '.txt','w');
         fprintf(fileID,[num2str(size_of_stack) '\n']);
            for m=1:size_of_stack
                fprintf(fileID,[micrograph_names{m} '\n']);
                fprintf(fileID,'0\n');
            end
          fclose(fileID);
          disp(['Done making list_ts_' + stackname + '.txt']);
          disp([' ']);
          
          
          %In case one wants to print all files on command window          
          %type(['list_ts_' + stackname + '.txt'])
          
    else disp(['<strong> TILTSERIES NUMBER '  num2str(stacks(c,1))  ' IS INCOMPLETE. </strong>']);
        disp([' ']);
        
    end
    
  
    % run newstack
    %disp('bash ctffind4_run.sh')
    c=c+1;
end
disp('<strong>All done! Check the files to make sure they are all in the correct order.</strong>');
