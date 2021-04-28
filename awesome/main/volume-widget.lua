local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(64)
local offsety = dpi(300)
local screen = awful.screen.focused()

-- create the volume_adjust component
local volume_adjust = wibox({
   screen = awful.screen.focused(),
   x = screen.geometry.width - offsetx,
   y = (screen.geometry.height / 2) - (offsety / 2),
   width = dpi(48),
   height = offsety,
   shape = gears.shape.rounded_rect,
   visible = false,
   ontop = true
})

local volume_bar = wibox.widget {
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    color = theme.yellow,
    background_color = theme.grey,
    max_value = 100,
    value = 0
}

function colorize(icon, color)
    return gears.color.recolor_image(icon, color)
end

volume_adjust:setup {
    layout = wibox.layout.align.vertical,
    {
        wibox.container.margin(volume_bar, dpi(14), dpi(20), dpi(20), dpi(20)),
        forced_height = offsety * 0.75,
        direction = "east",
        layout = wibox.container.rotate
    },
    wibox.container.margin(
        wibox.widget{
            image = colorize( theme.volume_up, theme.widget_main_color),
            widget = wibox.widget.imagebox
        }, dpi(10), dpi(10), dpi(14), dpi(14)
    ),
}

-- create a 2 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer {
    timeout = 4,
    autostart = true,
    callback = function()
        volume_adjust.visible = false
    end
}

-- show volume-adjust when "volume_change" signal is emitted
awesome.connect_signal("volume_change",
    function()
        -- set new volume value
        awful.spawn.easy_async_with_shell(
            "pulsemixer --get-volume | awk '{print $1}'",
            function(stdout)
                volume_bar.value = tonumber(stdout)
            end,
            false
        )

        -- make volume_adjust component visible
        if volume_adjust.visible then
            hide_volume_adjust:again()
        else
            volume_adjust.visible = true
            hide_volume_adjust:start()
        end
    end
)
