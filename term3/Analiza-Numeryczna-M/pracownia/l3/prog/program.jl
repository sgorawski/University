# Aleksander Czeszejko-Sochacki
# Slawomir Gorawski

# Splines implementation

function spline_linear(nodes::Vector, values::Vector)
    @assert length(nodes) == length(values)
    function(x)
        x0, x1 = Int(floor(x)), Int(ceil(x))
        x0 == x1 && return values[x0]
        y0, y1 = values[x0], values[x1]
        y0*(x-x1)/(x0-x1) + y1*(x-x0)/(x1-x0)
    end
end


function spline_cubic(nodes::Vector, values::Vector)
    @assert length(nodes) == length(values)
    n = length(nodes) - 1

    a = values
    h = [nodes[i+1] - nodes[i] for i = 1:n]
    α = vcat(0, [3/h[i]*(a[i+1] - a[i]) - 3/h[i-1]*(a[i] - a[i-1]) for i =2:n])
    l, μ, z = zeros(n+1), zeros(n), zeros(n+1)
    for i = 2:n
        l[i] = 2(nodes[i+1] - nodes[i-1]) - h[i-1]*μ[i-1]
        μ[i] = h[i] / l[i]
        z[i] = (α[i] - h[i-1]*z[i-1]) / l[i]
    end

    l[n+1] = 1
    b, c, d = zeros(n), zeros(n+1), zeros(n)
    for i = n:-1:1
        c[i] = z[i] - μ[i]*c[i+1]
        b[i] = (a[i+1] - a[i])/h[i] - h[i]/3*(c[i+1] + 2c[i])
        d[i] = (c[i+1] - c[i]) / 3h[i]
    end

    function(x)
        i = 1
        while x > nodes[i+1] i += 1 end
        a[i] + b[i]*(x - nodes[i]) + c[i]*(x - nodes[i])^2 + d[i]*(x - nodes[i])^3
    end
end


# 1-dimensional image expansion (vertical)

function expand_using_nearest_neighbours(img::Matrix, new_y::Int)
    old_y, old_x = size(img)
    new_img = Matrix{Float64}(new_y, old_x)
    
    for x = 1:old_x
        new_img[:, x] = map(1:new_y) do y
            p = 1 + (y-1)*(old_y-1) / (new_y-1)
            img[Int(round(p)), x]
        end
    end
    new_img
end


function expand_using_linear_spline(img::Matrix, new_y::Int)
    old_y, old_x = size(img)
    new_img = Matrix{Float64}(new_y, old_x)
    
    for x = 1:old_x
        spl = spline_linear(collect(1:old_y), img[:, x])
        new_img[:, x] = spl.(linspace(1, old_y, new_y))
    end
    new_img
end


function expand_using_cubic_spline(img::Matrix, new_y::Int)
    old_y, old_x = size(img)
    new_img = Matrix{Float64}(new_y, old_x)
    
    for x = 1:old_x
        spl = spline_cubic(collect(1:old_y), img[:, x])
        new_y_values = spl.(linspace(1, old_y, new_y))
        # Guards
        new_y_values = (x -> x > 1.0 ? 1.0 : x).(new_y_values)
        new_y_values = (x -> x < 0.0 ? 0.0 : x).(new_y_values)

        new_img[:, x] = new_y_values        
    end
    new_img
end


# MAIN FUNCTION
# Expands image twice using functions defined above

@enum METHOD nearest_neighbours linear_spline cubic_spline
@enum DIRECTION horizontal vertical


function resize(img::Matrix, new_x::Int, new_y::Int,
                method::METHOD, first_direction::DIRECTION)
    
    # Mapping enums to actual functions
    if method == nearest_neighbours
        transformation = expand_using_nearest_neighbours
    elseif method == linear_spline
        transformation = expand_using_linear_spline
    elseif method == cubic_spline
        transformation = expand_using_cubic_spline
    else
        throw(ArgumentError("Method not recognized"))
    end
    
    # Image rotation to reverse expansion order
    if first_direction == horizontal
        img = img'
        new_x, new_y = new_y, new_x
    end
    
    new_img = transformation(img, new_y)'
    new_img = transformation(new_img, new_x)'
    
    first_direction == horizontal && (new_img = new_img')
    
    new_img
end
