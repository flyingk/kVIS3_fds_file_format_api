%
%> @file kVIS_fdsAddTreeLeaf.m
%> @brief Add new leaf to fdata tree. Leafs contain data.
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
%> @brief Add new leaf to fdata tree. Leafs contain data.
%>
%> @param fds structure
%> @param Name of new group
%> @param Cell array of channel names
%> @param Cell array of channel display names
%> @param Cell array of channel units
%> @param Cell array of channel frames
%> @param Array of channel data (time as first cannel)
%> @param Name of parent node
%> @param Selected flag
%>
%> @retval Modified fds structure
%> @retval New node index
%
function [ fds, node ] = kVIS_fdsAddTreeLeaf(fds, groupLabel, vars, varsDisp, units, frame, data, parentGroup, selected)
%
% get the column number of the tree parent
%
treeParentID = kVIS_fdsResolveGroupID(fds, parentGroup);
%
% Check if group exists
%
[~, node] = kVIS_fdsGetGroup(fds, groupLabel);

%
% create, if not
%
if node <= 0
    
    % add a new column to fdata
    fds.fdata = [fds.fdata, cell(size(fds.fdata,1),1)];
    
    % populate new column
    fds.fdata{fds.fdataRows.groupID, end}      = kVIS_fdsUniqueGroupID(fds);
    fds.fdata{fds.fdataRows.groupLabel, end}   = groupLabel;
    fds.fdata{fds.fdataRows.varNames, end}     = vars;
    fds.fdata{fds.fdataRows.varUnits, end}     = units;
    fds.fdata{fds.fdataRows.varFrames, end}    = frame;
    fds.fdata{fds.fdataRows.varNamesDisp, end} = varsDisp;
    fds.fdata{fds.fdataRows.data, end}         = data;
    fds.fdata{fds.fdataRows.treeParent, end}   = treeParentID;
    fds.fdata{fds.fdataRows.treeGroupSelected, end} = selected;
    fds.fdata{fds.fdataRows.treeGroupExpanded, end} = false;
    
    % number of this node
    node = size(fds.fdata, 2);
    
else
    
    % handle duplicated groups
    % need to ensure that full path is unique
    warning('kVIS_fdsAddTreeLeaf::Group name exists, path unique??')
    
    % add a new column to fdata
    fds.fdata = [fds.fdata, cell(size(fds.fdata,1),1)];
    
    % populate new column
    fds.fdata{fds.fdataRows.groupID, end}      = kVIS_fdsUniqueGroupID(fds);
    fds.fdata{fds.fdataRows.groupLabel, end}   = groupLabel;
    fds.fdata{fds.fdataRows.varNames, end}     = vars;
    fds.fdata{fds.fdataRows.varUnits, end}     = units;
    fds.fdata{fds.fdataRows.varFrames, end}    = frame;
    fds.fdata{fds.fdataRows.varNamesDisp, end} = varsDisp;
    fds.fdata{fds.fdataRows.data, end}         = data;
    fds.fdata{fds.fdataRows.treeParent, end}   = treeParentID;
    fds.fdata{fds.fdataRows.treeGroupSelected, end} = selected;
    fds.fdata{fds.fdataRows.treeGroupExpanded, end} = false;
    
    % number of this node
    node = size(fds.fdata, 2);
    
end

end