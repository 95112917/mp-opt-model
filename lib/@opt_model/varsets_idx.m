function kk = varsets_idx(om, vs)
%VARSETS_IDX  Returns a vector of indices into X specified by VARSETS
%   K = OM.VARSETS_IDX(VARSETS)
%
%   Returns a vector of indices into X corresponding to the variable
%   sets specified by VARSETS.
%
%   See also VARSET_X

%   MATPOWER
%   Copyright (c) 2017, Power Systems Engineering Research Center (PSERC)
%   by Ray Zimmerman, PSERC Cornell
%
%   This file is part of MATPOWER.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See http://www.pserc.cornell.edu/matpower/ for more info.

k = {};                 %% indices for varsets

%% calls to substruct() are relatively expensive, so we pre-build the
%% struct for addressing numeric array fields, updating only
%% the subscripts before use
sn = struct('type', {'.', '()'}, 'subs', {'', 1});

for v = 1:length(vs)
    vname = vs(v).name;
    vidx = vs(v).idx;
    if isempty(vidx)
        i1 = om.var.idx.i1.(vname);         %% starting index in full x
        iN = om.var.idx.iN.(vname);         %% ending index in full x
    else
        % (calls to substruct() are relatively expensive ...
        % sn = substruct('.', vname, '()', vidx);
        % ... so replace it with these more efficient lines)
        sn(1).subs = vname;
        sn(2).subs = vidx;
        i1 = subsref(om.var.idx.i1, sn);    %% starting index in full x
        iN = subsref(om.var.idx.iN, sn);    %% ending index in full x
    end
    k{v} = (i1:iN);     %% indices for varset
end
kk = [k{:}];
