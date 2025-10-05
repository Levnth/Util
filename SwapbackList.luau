--!strict

local SwapbackList = {}
SwapbackList.__index = SwapbackList

type self<T> = {
    _ValueToIndex: {[T]: number},
    List: {T},
}
export type SwapbackList<T> = typeof(setmetatable({} :: self<T>, SwapbackList))

function SwapbackList.new<T>(): SwapbackList<T>
    local self = setmetatable({}, SwapbackList) :: SwapbackList<T>
    self._ValueToIndex = {}
    self.List = {}
    return self
end

function SwapbackList.Insert<T>(self: SwapbackList<T>, value: T)
    assert(self._ValueToIndex[value] == nil, "[SwapbackList]: Value already in list.")
    table.insert(self.List, value)
    self._ValueToIndex[value] = #self.List
end

function SwapbackList.Remove<T>(self: SwapbackList<T>, value: T): T
    local index = self._ValueToIndex[value]
    assert(index, "[SwapbackList]: Unable to find the object to be removed.")
    local last = table.remove(self.List) :: T
    if last ~= value then
        self.List[index] = last
        self._ValueToIndex[last] = index
    end
    self._ValueToIndex[value] = nil
    return value
end

function SwapbackList.Empty<T>(self: SwapbackList<T>)
    table.clear(self._ValueToIndex)
    table.clear(self.List)
end

function SwapbackList.Contains<T>(self: SwapbackList<T>, value: T)
    return self._ValueToIndex[value] ~= nil
end

return SwapbackList
