module ManagersHelper
    def output1(var)
        if var.nil?
            return "";
        end
        if var == ''
            return "";
        end
        if var == ' '
            return "";
        end
        return var
    end
    def outputCijena1(var)
        if var.nil?
            return "";
        end
        if var == ''
            return "";
        end
        return var.to_s
    end

    def isAuthorInsideArray(polje, var)
        for el in polje
            if el["autor"] == var
                return true
            end
        end
        return false
    end
end