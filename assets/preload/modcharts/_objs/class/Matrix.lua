local indices = {
	"a", "b", "c",
	"d", "tx", "ty"
}

local matrix = {userdata = "matrix"}
matrix.__index = function(t, i)
	return (type(i) == "number" and i >= 1 and i <= 6) and t[indices[i]] or matrix[i]
end
matrix.__newindex = function(t, i, v)
	return (type(i) == "number" and i >= 1 and i <= 6) and rawset(t, indices[i], v) or error("Cannot set a variable in read-only userdata")
end

function matrix.new(a, b, c, d, tx, ty)
	return setmetatable(matrix.setTo({}, a, b, c, d, tx, ty), matrix)
end

function matrix.clone(mat)
	return matrix.new(mat.a, mat.b, mat.c, mat.d, mat.tx, mat.ty)
end

function matrix.copyFrom(mat, fr)
	mat:setTo(
		fr.a, fr.b, fr.c,
		fr.d, fr.tx, fr.ty
	)
	
	return mat
end

function matrix.setTo(mat, a, b, c, d, tx, ty)
	mat.a = a or 1
	mat.b = b or 0
	mat.c = c or 0
	mat.d = d or 1
	mat.tx = tx or 0
	mat.ty = ty or 0
	
	return mat
end

function matrix.components(mat)
	return mat.a, mat.b, mat.c,
		mat.d, mat.tx, mat.ty
end

function matrix.identity(mat)
	return matrix.setTo(mat)
end

function matrix.translate(mat, x, y)
	mat.tx, mat.ty = mat.tx + (x or 0), mat.ty + (y or 0)
	return mat
end

function matrix.scale(mat, sx, sy)
	sx = sx or 0
	sy = sy or 0
	
	mat.a = mat.a * sx
	mat.b = mat.b * sy
	mat.c = mat.c * sx
	mat.d = mat.d * sy
	mat.tx = mat.tx * sx
	mat.ty = mat.ty * sy
	
	return mat
end

function matrix.concat(mat, a, b, c, d, tx, ty)
	if (type(a) == "table") then
		return matrix.concat(mat, a.a, a.b, a.c, a.d, a.tx, a.ty)
	end
	
	local a1 = mat.a * a + mat.b * c
	mat.b = mat.a * b + mat.b * d
	mat.a = a1

	local c1 = mat.c * a + mat.d * c
	mat.d = mat.c * b + mat.d * d
	mat.c = c1

	local tx1 = mat.tx * a + mat.ty * c + tx
	mat.ty = mat.tx * b + mat.ty * d + ty
	mat.tx = tx1
	
	return mat
end

function matrix.rotate(mat, theta)
	local rad = math.rad(theta or 0)
	local rotCos, rotSin = math.cos(rad), math.sin(rad)
	
	local a1 = mat.a * rotCos - mat.b * rotSin
	mat.b = mat.a * rotSin + mat.b * rotCos
	mat.a = a1
	
	local c1 = mat.c * rotCos - mat.d * rotSin
	mat.d = mat.c * rotSin + mat.d * rotCos
	mat.c = c1
	
	local tx1 = mat.tx * rotCos - mat.ty * rotSin
	mat.ty = mat.tx * rotSin + mat.ty * rotCos
	mat.tx = tx1
	
	return mat
end

function matrix.skew(mat, x, y)
	local skb, skc = math.tan(math.rad(y or 0)), math.tan(math.rad(x or 0))
	
	mat.b = mat.a * skb + mat.b
	mat.c = mat.c + mat.d * skc
	
	mat.ty = mat.tx * skb + mat.ty
	mat.tx = mat.tx + mat.ty * skc
	
	return mat
end

function matrix.prepend(mat, rhs)
	--[[
	local m3 = {}
        for r = 1, #m1 do
            local row = {}
            for c = 1, #m2[1] do
                local sum = 0
                for i = 1, #m1[1] do
                    sum = sum + m1[r][i] * m2[i][c]
                end
                row[c] = sum
            end
            m3[r] = row
        end
        return m3
	]]
	
	local m111, m121 = rhs[1], rhs[4]
	local m112, m122 = rhs[2], rhs[5]
	local m113, m123 = rhs[3], rhs[6]
	
	local m211, m221 = mat[1], mat[4]
	local m212, m222 = mat[2], mat[5]
	local m213, m223 = mat[3], mat[6]
	
	mat[1] = m111 * m211 + m112 * m221 + m113
	mat[2] = m111 * m212 + m112 * m222
	mat[3] = m111 * m213 + m112 * m223
	
	mat[4] = m121 * m211 + m122 * m221 + m123
	mat[5] = m121 * m212 + m122 * m222
	mat[6] = m121 * m213 + m122 * m223
	
	return mat
end

return matrix