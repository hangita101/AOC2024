left_lst = Vector{Int}()
right_lst = Vector{Int}()


file_content = read("Day1/Input.txt", String)

lines = convert.(String, split(file_content, "\n"))



for line in lines
    lst = split(line, "   ")

    push!(left_lst, parse(Int, lst[1]))
    push!(right_lst, parse(Int, lst[2]))
end

# part 1

sort!(left_lst)
sort!(right_lst)

function distance(lst1, lst2)
    dis = 0
    for (i, j) in zip(lst1, lst2)
        dis += abs(i - j)
    end
    return dis
end

dist = distance(left_lst, right_lst)


# part 2

function similarity(lst1, lst2)
    adder = 0
    for i in lst1
        count = 0
        for j in lst2
            if i == j
                count += 1
            end
        end
        adder += count * i
    end
    return adder
end


using BenchmarkTools

@btime similarity(left_lst, right_lst)
# 80.951 μs (1 allocation: 16 bytes)
# 29379307

function bsearch(lst::Vector{Int}, item::Int)
    low = 1
    high = length(lst)

    while low <= high
        mid = convert(Int, round(low + (high - low) / 2))

        if (lst[mid] == item)
            return mid

        elseif (lst[mid] < item)
            low = mid + 1
        else
            high = mid - 1
        end
    end


    return -1
end

function similarity2(lst1::Vector{Int}, lst2::Vector{Int})
    adder = 0
    flag = false
    for i in lst1
        count = 0
        for j in lst2
            if (i != j)
                if flag
                    break
                end
            elseif i == j
                flag = true
                count += 1
            end
        end
        adder += count * i
        flag = false
    end
    return adder
end

similarity2(left_lst, right_lst)
@btime similarity2(left_lst, right_lst)
# 465.271 μs (0 allocations: 0 bytes)
# 29379307

length(Set(right_lst))


function similarity3(lst1::Vector{Int}, lst2::Vector{Int})
    adder = 0
    flag = false
    for i in lst1
        count = 0
        if bsearch(lst2, i) == -1
            continue
        end
        for j in lst2
            if (i != j)
                if flag
                    break
                end
            elseif i == j
                flag = true
                count += 1
            end
        end
        adder += count * i
        flag = false
    end
    return adder
end

similarity3(right_lst, left_lst)
@btime similarity3(left_lst, right_lst)
#   91.297 μs (0 allocations: 0 bytes)
# 29379307

function similarity4(lst1::Vector{Int}, lst2::Vector{Int})
    freq_map = Dict{Int,Int}()
    for j in lst2
        freq_map[j] = get(freq_map, j, 0) + 1
    end

    adder = 0
    for i in lst1
        count = get(freq_map, i, 0)
        adder += count * i
    end

    return adder, freq_map
end
a, mapp = similarity4(right_lst, left_lst)
#  21.459 μs (23 allocations: 91.16 KiB)
#29379307

function similarity5(lst1::Vector{Int}, lst2::Vector{Int})
    freq_map = Dict{Int,Int}()
    for j in lst2
        freq_map[j] = get(freq_map, j, 0) + 1
    end

    adder = 0
    for i in lst1
        count = get(freq_map, i, 0)
        adder += count * i
    end

    return adder, freq_map
end

length(Set(right_lst))


function createMap(right_lst)
    map = Dict{Int,Int}()
    for i in right_lst
        map[i] = get(map, i, 0) + 1
    end
    return map
end

map =createMap(right_lst)

function similaritymap(left_lst::Vector{Int}, map::Dict{Int,Int})
    adder = 0
    for i in left_lst
        count = get(map, i, 0)
        adder += count * i
    end
    adder

end

@btime similaritymap(left_lst, map)
# 2.960 μs (1 allocation: 16 bytes)
# 29379307