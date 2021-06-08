%
%> @file kVIS_fdsUniqueGroupID.m
%> @brief Generate a unique hex number for use as tree group ID
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
%> @brief Generate a unique hex number for use as tree group ID
%>
%> @param  fds structure (to check if generated number is indeed unique)
%> @retval New group ID string
%
function [ID] = kVIS_fdsUniqueGroupID(fds)

% generate random string of 20 lower case letters
% ID = char(randi([97 122],1,20));

% generate random number with 12 digits
num = randi([1e12, 10e12],1);

% convert to hex format
hex = dec2hex(num);

% assemble ID string
IDcandidate = ['0x' hex];

% check if unique (randi can repeat)
idx = strcmp(fds.fdata(fds.fdataRows.groupID,:), IDcandidate);

if any(idx)
    errordlg('non unique group ID')
else
    ID = IDcandidate;
end

end

