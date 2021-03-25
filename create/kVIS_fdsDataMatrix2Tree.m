%
%> @file kVIS_fdsDataMatrix2Tree.m
%> @brief Creates a FDS tree from a data matrix and corresponding data names.
%
%
% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%
%> @brief Creates a FDS tree from a data matrix and corresponding data names.
%>
%> Creates a FDS tree from a data matrix and corresponding data names.
%> If name string can be split in to groups, the function will attempt to
%> identify common groups using the delimiter. The sample time is assumed
%> to be the first channel of the matrix and assumed common to all data.
%>
%> @param Name of BSP
%> @param Name of root node
%> @param Delimiter used in name list
%> @param Array of data channels in columns with time vector as column 1
%> @param Flag to skip last column - useful for CSV files with corrupt row endings
%>
%> @retval Created fds structure
%
function [fds] = kVIS_fdsDataMatrix2Tree(bspName, rootName, delimiter, dataNames, data, skipLast)

%
% init new fds
%
fds = kVIS_fdsInitNew();
%
% set bsp name
%
fds.BoardSupportPackage = bspName;
%
% add root node
%
[fds, parentNode0] = kVIS_fdsAddTreeBranch(fds, 0, rootName);


waitb = waitbar(0,'Building FDS structure. Please wait...');
%
% time vector - assumed common to all data
%
timeVec = data(:,1);
%
% build fds.fdata structure without data (initialise for speed, fill data
% in second step)
%
for k = 2 : numel(dataNames) - skipLast % first entry is time vector, last entry is potentially empty
    
    %updating waitbar every 10%
    hfrac = k/(numel(dataNames) - skipLast);
    if mod(hfrac,0.05)<0.001
        waitbar(hfrac, waitb)
    end
    
    Path = strsplit(dataNames{k}, delimiter);
    Path = strip(Path);
    
    Name = Path{end};
    Path = Path(1:end-1);
    
    if isempty(Path)
        Path = {'Unsorted'}; % put in default group
        continue;
    end
    
    % Find or create group
    ParentIdx = parentNode0;
    
    
    for P = 1 : numel(Path)
        
        % build path to current index
        if P == 1
            pathstr = [rootName '/' Path{1}];
        else
            pathstr = [pathstr '/' Path{P}];
        end
        
        % current group name
        GroupName = Path{P};
        
        % does current group name exist in tree?
        [groupIdx] = kVIS_fdsGetGroupLabelColumnIndex(fds, GroupName);
        
        if groupIdx == -1
            
            % no match - create new entry
            [ fds, ParentIdx ] = createNewEntry(fds, Path, P, GroupName, Name, ParentIdx, data, k);
            
            
        elseif length(groupIdx) == 1
            
            % single match - potentially existing group -> check if path is
            % correct
            % Yes:
            % add data if at leaf level or
            % update parent index if at branch level
            % No:
            % add new group with that path
            
            % check if path is unique to this group.
            treepath = kVIS_fdsBuildTreePath(fds, fds.fdata{fds.fdataRows.groupID, groupIdx});
            
            if ~strcmp(pathstr,treepath)
                % path is different -> new group
                pathstr;
                treepath;
                
                [ fds, ParentIdx ] = createNewEntry(fds, Path, P, GroupName, Name, ParentIdx, data, k);
                
            else
                % path exists -> add item to leaf
                [ fds, ParentIdx ] = addToEntry(fds, Path, P, Name, groupIdx, data, k);
            end
            
        elseif length(groupIdx) > 1
            
            % multiple results: either one of them or new group...
            disp(['multiple entries found: ' GroupName])
                        
            % need to loop through matches (1 match case above) until one is found, otherwise
            % create new group...
            
            for nn = 1:length(groupIdx)
                
                % need to check if path is unique to this group.
                treepath = kVIS_fdsBuildTreePath(fds, fds.fdata{fds.fdataRows.groupID, groupIdx(nn)});
                
                if strcmp(pathstr,treepath)
                    % group exists -> add here
                    pathstr;
                    treepath;
                    [ fds, ParentIdx ] = addToEntry(fds, Path, P, Name, groupIdx(nn), data, k);
                    nn=-1;
                    break;
                end
            end
            
            % still not found? add new.
            if nn > 0
                pathstr
                [ fds, ParentIdx ] = createNewEntry(fds, Path, P, GroupName, Name, ParentIdx, data, k);
            end
            
        else
            
            % this should not happen
            disp('bad.')
            groupIdx
            GroupName
            Name
        end
        
    end
    
end
%
% Tree structure as been built at this point.
%


%
% pre-allocate data arrays before adding data channels for speed
%
for k = 1:size(fds.fdata, 2)
    
    if size(fds.fdata{fds.fdataRows.varNames, k}) > 0
        
        fds.fdata{fds.fdataRows.data, k} = zeros(length(timeVec), size(fds.fdata{fds.fdataRows.data, k},2));
        
        fds.fdata{fds.fdataRows.data, k}(:,1) = timeVec;
    end
end


%
% copy data into fdata array
%
for k = 2 : numel(dataNames) - skipLast % first entry is time vector, last entry is potentially empty

    %updating waitbar every 10%
    hfrac = k/(numel(dataNames) - skipLast);
    if mod(hfrac,0.05)<0.001
        waitbar(hfrac, waitb)
    end

    Path = strsplit(dataNames{k}, delimiter);
    Path = strip(Path);

    Name = Path{end};
    Path = Path(1:end-1);

    if isempty(Path)
        Path = {'Unsorted'}; % put in default group
        continue;
    end

    for P = 1 : numel(Path)
        % build path to current index
        if P == 1
            pathstr = [rootName '/' Path{1}];
        else
            pathstr = [pathstr '/' Path{P}];
        end

        % only interested in data leafs
        if P == numel(Path)
            
            % current group name
            GroupName = Path{P};
            
            % does current group name exist in tree where and how often?
            [groupIdx] = kVIS_fdsGetGroupLabelColumnIndex(fds, GroupName);
            
            % go through all matches to find correct path
            for nn = 1:length(groupIdx)
                
                treepath = kVIS_fdsBuildTreePath(fds, fds.fdata{fds.fdataRows.groupID, groupIdx(nn)});
                
                if strcmp(pathstr,treepath)
                    % group matched -> add data here
                    pathstr;
                    treepath;
                    [ fds ] = kVIS_fdsFillTreeLeafItemLocal(fds, groupIdx(nn), Name, data(:,k));
                    break;
                end
            end
          
        end

    end

end

fds = kVIS_fdsUpdateAttributes(fds);

close(waitb)
end

%
% create a new tree entry (branch or leaf)
%
function [ fds, ParentIdx ] = createNewEntry(fds, Path, P, GroupName, Name, ParentIdx, data, k)

timeVec = data(:,1);

if P == numel(Path)
    % data leaf with time vector as first entry
    [fds, node] = kVIS_fdsAddTreeLeaf(fds, GroupName, {'Time'}, {'Time'}, {'sec'}, {'-'}, timeVec(1), ParentIdx, false);
    
    [ fds ] = kVIS_fdsAddTreeLeafItem(fds, node, Name, Name, {'-'}, {'-'}, data(1,k));
    
else
    % sorting branch
    [fds, ParentIdx] = kVIS_fdsAddTreeBranch(fds, ParentIdx, GroupName);
end

end

%
% add to tree leaf
%
function [ fds, ParentIdx ] = addToEntry(fds, Path, P, Name, groupIdx, data, k)

timeVec = data(:,1);

ParentIdx = groupIdx;

if P == numel(Path)
    
    % new channels added after group created and filled with sub-groups
    if isempty(fds.fdata{fds.fdataRows.varNames, ParentIdx})
        [ fds ] = kVIS_fdsAddTreeLeafItem(fds, ParentIdx, 'Time', 'Time', {'sec'}, {'-'}, timeVec(1));
    end
    
    [ fds ] = kVIS_fdsAddTreeLeafItem(fds, ParentIdx, Name, Name, {'-'}, {'-'}, data(1,k));
else
    % do nothing
    
    %                 disp('bad. bad.')
    %                 groupIdx
    %                 GroupName
    %                 Name
end

end


function [ fds ] = kVIS_fdsFillTreeLeafItemLocal(fds, group, var, data)

%
% Add new data to a tree leaf. SPECIAL VERSION TO DEAL WITH NON-NUMERIC
% DATA...

% var
% fds.fdata{fds.fdataRows.varNames, group}
findChannel = strcmp(fds.fdata{fds.fdataRows.varNames, group}, var);

if sum(findChannel) > 1
    disp(['Duplicate channel name found in group. Skipping. <' var '>'])
    return
end

if ~isnumeric(data)
    %disp(['group' group 'contains non-numeric data... Bad :('])
    data = str2double(data);
end

fds.fdata{fds.fdataRows.data, group}(:,findChannel) = data;
end


