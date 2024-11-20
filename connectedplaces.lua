for _,v in pairs(game.AssetService:GetGamePlacesAsync():GetCurrentPage()) do  print(v.PlaceId .. "  -  " .. game:GetService("MarketplaceService"):GetProductInfo(v.PlaceId).Name)  end
