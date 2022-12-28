-- add a command to open the window
concommand.Add( "odc_open_window", function( ply, cmd, args )
    local Frame = vgui.Create( "DFrame" )
    Frame:SetPos( 5, 20 )
    Frame:SetSize( 300, 150 )
    Frame:SetTitle( "Name window" )
    Frame:SetVisible( true )
    Frame:SetDraggable( false )
    Frame:ShowCloseButton( true )

    -- live updating roll timer
    rollTimer = vgui.Create( "DLabel", Frame )
    rollTimer:SetPos( 5, 30 )
    rollTimer:SetSize( 300, 20 )
    rollTimer:SetText( "Roll timer: 0" )
    rollTimer:SetTextColor( Color( 255, 255, 255 ) )

    function Frame:Think()
        -- Get variable from current player
        rollTimer:SetText( "Roll timer: " .. tostring(ply:GetWallDirection()) )
    end
end )