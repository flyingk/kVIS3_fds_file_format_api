%
%> @file kVIS_fdsResolveGroupID.m
%> @brief Resolve a given group identifier into a group ID and corresponding fdata column
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
%> @brief Resolve a given group identifier into a group ID and corresponding fdata column
%>
%> @param fds structure
%> @param Name of group
%>
%> @retval Group ID
%> @retval Group fdata column index
%
function [ID, Col] = kVIS_fdsResolveGroupID(fds, Group)

if isnumeric(Group)
    % column number given (always unique, may change over life of file)
    
    if Group <= size(fds.fdata,2)
        
        ID = fds.fdata{fds.fdataRows.groupID, Group};
        
        Col = Group;
        
    else
        
        error(['kVIS_fdsResolveGroupID::Given group number does not exist: ' num2str(Group)])
        
    end
    
elseif ischar(Group) && startsWith(Group, '0x')
    % group ID given (always unique)
    
    ID = Group;
    
    Col = kVIS_fdsGetGroupIDColumnIndex(fds, Group);
    
    if Col == -1
        
        error(['kVIS_fdsResolveGroupID::Given group does not exist: ' Group])
        
    end
    
elseif ischar(Group) && contains(Group, '/')
    % full/partial path given (always/must be unique)
    
    % Search corresponding column using the full tree path
    for I = 1:size(fds.fdata,2)
        
        % build the tree path for each group and check if it
        % contains the identifier
        groupID = fds.fdata{fds.fdataRows.groupID, I};
        
        treePath = kVIS_fdsBuildTreePath(fds, groupID);
        
        found(I) = contains(treePath, Group); %#ok<AGROW>
        
    end
    
    Col = find(found==true);
    
    if length(Col) > 1
        
        error(['kVIS_fdsResolveGroupID::Given path not unique: ' Group])
        
    elseif isempty(Col)
        
        error(['kVIS_fdsResolveGroupID::Given path does not exist: ' Group])
        
    else
        
        ID = fds.fdata{fds.fdataRows.groupID, Col};
        
    end
    
elseif ischar(Group)
    % group name given (may NOT be unique)
    
    Col = kVIS_fdsGetGroupLabelColumnIndex(fds, Group);
    
    if length(Col) > 1
        
        error(['kVIS_fdsResolveGroupID::Group not unique: ' Group])
        
    elseif Col == -1
        
        error(['kVIS_fdsResolveGroupID::Given group does not exist: ' Group])
        
    else
        
        ID = fds.fdata{fds.fdataRows.groupID, Col};
        
    end
    
else
    
    error(['kVIS_fdsResolveGroupID::Bad Group specification: ' Group])
    
end

end