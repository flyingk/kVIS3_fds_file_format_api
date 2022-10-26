%
%> @file kVIS_fdsGetChannel.m
%> @brief Returns data content of a channel
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
%> @brief Returns data content of a channel
%>
%> @param fds data structure
%> @param Group identifier to search
%> @param Channel name to search
%>
%> @retval Data content of group as array or -1 if not found
%> @retval Meta data for channel or -1 if not found
%
function [signal, signalMeta] = kVIS_fdsGetChannel(fds, groupName, channel)

% group name might exist -> channel could be duplicated as well -> need to
% find the correct group
% channel is unique in a group, so if group is unique, then channel will be
% as well

if ~isstruct(fds)
    warning('No fds structure specified...')
    signal = -1;
    signalMeta = -1;
    return
end

%% find the correct group
[groupData, groupNo] = kVIS_fdsGetGroup(fds, groupName);

if groupNo == -1
    warning('kVIS_fdsGetChannel: Invalid group name.')
    signal = -1;
    signalMeta = -1;
    return
end


%% find channel name in group
if isnumeric(channel)
    % direct specification of channel index
    if channel <= size(groupData,2)
        channel_idx = channel;
    else
        warning(['kVIS_fdsGetChannel: Invalid channel specification: Channel no: ' num2str(channel)])
        signal = -1;
        signalMeta = -1;
        return
    end
    
elseif ischar(channel)
    % search for channel name
    channel_idx = strcmp(fds.fdata{fds.fdataRows.varNames, groupNo}, channel);
    
    if ~any(channel_idx)
        warning('kVIS_fdsGetChannel: Invalid channel name.')
        signal = -1;
        signalMeta = -1;
        return
    end
    
else
    
    warning('kVIS_fdsGetChannel: Invalid channel specification.')
    signal = -1;
    signalMeta = -1;
    return
end
%
% signal data
%
signal = fds.fdata{fds.fdataRows.data,groupNo}(:,channel_idx);
%
% signal meta data as strings, vector
%
signalMeta.name      = fds.fdata{fds.fdataRows.varNames, groupNo}{channel_idx};
signalMeta.unit      = fds.fdata{fds.fdataRows.varUnits, groupNo}{channel_idx};
signalMeta.frame     = fds.fdata{fds.fdataRows.varFrames, groupNo}{channel_idx};
signalMeta.dispName  = fds.fdata{fds.fdataRows.varNamesDisp, groupNo}{channel_idx};
signalMeta.dataSet   = 'unknown';
signalMeta.dataGroup = fds.fdata{fds.fdataRows.groupLabel, groupNo};
signalMeta.dataPath  = kVIS_fdsBuildTreePath(fds, fds.fdata{fds.fdataRows.groupID, groupNo});
signalMeta.timeVec   = fds.fdata{fds.fdataRows.data, groupNo}(:, 1);
signalMeta.sampleRate = fds.fdataAttributes.sampleRates(groupNo);

end
