%
%> @file kVIS_fdsCreateEmptyEventList.m
%> @brief Create an empty event list structure
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
%> @brief Create an empty event list structure
%>
%>
%> @retval event list structure
%> @retval cell array of default event types
%
function [ eventList, eventTypes ] = kVIS_fdsCreateEmptyEventList()

eventList = struct( ...
    'type'       , {}, ... event type (non-unique)
    'start'      , {}, ... start time, relative to the `startTime` field in `testInfo`
    'end'        , {}, ... end time, relative to the `startTime` field in `testInfo`
    'description', {}, ... optional description
    'plotDef'    , {}  ... linked custom plot definition provided by the BSP
    );

eventTypes = {'unspecified', 'armed'};

end
