for _, stackable_prototype in pairs{'loader-1x1', 'loader', 'inserter'} do
    for _, stackable in pairs(data.raw[stackable_prototype]) do
        stackable.max_belt_stack_size = stackable.max_belt_stack_size or 1
        if stackable.max_belt_stack_size ~= 1 then
            stackable.max_belt_stack_size = data.raw["utility-constants"].default.max_belt_stack_size
        end
    end
end