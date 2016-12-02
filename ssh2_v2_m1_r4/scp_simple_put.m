function ssh2_struct = scp_simple_put(hostname, username, password, localFilename, remotePath, localPath, remoteFilename)
% SCP_SIMPLE_PUT   creates a simple SSH2 connection and send a remote file
%
%   SCP_SIMPLE_PUT(HOSTNAME,USERNAME,PASSWORD,LOCALFILENAME,[REMOTEPATH][LOCALPATH],REMOTEFILENAME)
%   Connects to the SSH2 host, HOSTNAME with supplied USERNAME and
%   PASSWORD. Once connected the LOCALFILENAME is uploaded from the
%   remote host using SCP. The connection is then closed.
%
%   LOCALFILENAME can be either a single string, or a cell array of strings. 
%   If LOCALFILENAME is a cell array, all files will be downloaded
%   sequentially.
%
%   OPTIONAL INPUTS:
%   -----------------------------------------------------------------------
%   REMOTEPATH specifies a specific path to upload the file to. Otherwise, 
%   the default (home) folder is used.
%   LOCALPATH specifies the folder to find the LOCALFILENAME in the file
%   is outside the working directory.
%   REMOTEFILENAME can be specified to rename the file on the remote host.
%   If LOCALFILENAME is a cell array, REMOTEFILENAME must be too.
% 
%   SCP_SIMPLE_PUT returns the SSH2_CONN for future use.
%
%see also scp_get, scp_put, scp, ssh2, ssh2_simple_command
%
% (c)2011 Boston University - ECE
%    David Scott Freedman (dfreedma@bu.edu)
%    Version 2.0

if nargin < 4
    ssh2_struct = [];
    help scp_simple_put
else
    if nargin < 5
        remotePath = '';
    end
    
    if nargin < 6
        localPath=GetSimStorageFolder();%GetExecutableFolder();
    elseif isempty(localPath)
        localPath=GetSimStorageFolder();%GetExecutableFolder();
    end    

    ssh2_struct = ssh2_config(hostname, username, password);

    if nargin >= 7
        ssh2_struct.remote_file_new_name = remoteFilename;
    else 
        remoteFilename = [];
    end
    
    
    ssh2_struct = ssh2_config(hostname, username, password);
    ssh2_struct.close_connection = 1; %close connection use
    try
        ssh2_struct = scp_put(ssh2_struct, localFilename, remotePath, localPath, remoteFilename);
    catch ME % Error: SSH2 could not connect to the ssh2 host
        password=inputdlg(['Password for ' username '@' hostname]);
        ssh2_struct = ssh2_config(hostname, username, password{:});
        ssh2_struct = scp_put(ssh2_struct, localFilename, remotePath, localPath, remoteFilename);
            global pswd
            pswd=password;
    end
end


    
