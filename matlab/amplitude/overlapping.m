function overlap = overlapping(fk,gk,ro)

npq = length(find(fk == gk));
np = length(fk);
nq = length(gk);
overlap = (np+nq-npq)./ro;



end