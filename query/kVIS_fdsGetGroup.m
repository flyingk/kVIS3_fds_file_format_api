%
%> @file kVIS_fdsGetGroup.m
%> @brief Return data content of a tree group
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
%> @brief Return data content of a tree group
%>
%> @param fds data structure
%> @param Group name to search
%> @param Optional additional UNIQUE group identifier (if group name not unique)
%>
%> @retval Data content of group as array or -1 if not found
%> @retval fds.fdata column index of the group
%
function [data, index] = kVIS_fdsGetGroup(fds, groupName, varargin)

if ~isstruct(fds)
    disp('No fds structure specified...')
    data = -1;
    index = -1;
    return
end

idx = kVIS_fdsGetGroupLabelColumnIndex(fds, groupName);


if (idx == -1)
    fprintf('Group name %s does not exist\n',groupName);
    data = -1;
    index = -1;
    return
    
elseif length(idx) > 1
    % multiple entries with identical name
    
    if nargin > 2
        
        % Use additional identifier
        ID2 = varargin{1};
        
        % Search corresponding idx in full tree path
        for I = 1:length(idx)
            
            groupID = fds.fdata{fds.fdataRows.groupID, idx(I)};
            
            treePath = kVIS_fdsBuildTreePath(fds, groupID);
            
            % use / so parts of strings won't be found??
            found(I) = contains(treePath, ID2);
            
        end
        
        idx2 = find(found==true);
        
        if length(idx2) == 1
            
            data = fds.fdata{fds.fdataRows.data, idx(idx2)};
            index = idx(idx2);
            
        else
            
            errordlg('kVIS_fdsGetGroup: Multiple/no entries found...Abort')
            data = -1;
            index = -1;
            
        end
        
    else
        
        errordlg('kVIS_fdsGetGroup: Multiple entries found...Abort')
        data = -1;
        index = -1;
    end
    
    
    return
else
    data = fds.fdata{fds.fdataRows.data,idx};
    index = idx;
end

return
end
