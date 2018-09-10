function mfiles = folder2mfileCellArray(inputFolder)
%FOLDER2CELLARRAY Summary of this function goes here
%   Detailed explanation goes here

    mfiles = i_folder2mfileCellArray(inputFolder);

end

function mfiles = i_folder2mfileCellArray(inputFolder)

    mfiles = cell(0,1);

    content = dir(inputFolder);
    content(1:2) = []; % Remove . and ..
    for c = 1:length(content)
        if content(c).isdir
            i_mfiles = i_folder2mfileCellArray(fullfile(inputFolder,content(c).name));
            if (~isempty(i_mfiles))
                mfiles = [mfiles i_mfiles];
            end
        else
            [~, ~, ext] = fileparts(content(c).name);
            if (strcmp(ext,'.m'))
                mfiles{end+1} = fullfile(inputFolder, content(c).name);
            end
        end
    end

end