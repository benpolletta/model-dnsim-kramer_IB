function vary_out = set_vary_field(vary, field, value)
% Either returns or sets the field in a vary cell array from DynaSim.
% If field is a string, picks based on parameter name.
% If field is a cell array of strings, picks based on mechanism name and
% parameter name.

if ischar(field)
    
    param_index = strcmp(vary(:,2), field);
    
elseif iscell(field)
    
    param_index = strcmp(vary(:,1), field{1}) & strcmp(vary(:,2), field{2});
    
end

vary_out = vary;

if isempty(value)
    
    vary_out(param_index, :) = [];
    
else
    
    vary_out{param_index, 3} = value;
    
end

end