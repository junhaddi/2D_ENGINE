/// @description 2D Platform Engine
///	@param key_left
///	@param key_right
///	@param key_jump
///	@param key_sit


//	Get Player Input
var key_left, key_right, key_jump, key_sit;
key_left = argument0;
key_right = argument1;
key_jump = argument2;
key_sit = argument3;

//	Cal Direction
var chr_movDir;
chr_movDir = key_right - key_left;

//	Set Xdir
if (chr_movDir != 0)
	chr_xdir = chr_movDir;

//	Set Speed
chr_vspeed += chr_gravity;
if (chr_movDir != 0)
	chr_hspeed = chr_hspeed + chr_accSpeed * chr_movDir;
else
{  
	chr_hspeed -= chr_friction * sign(chr_xdir);
	if (chr_xdir == 1)
		chr_hspeed = max(0, chr_hspeed);
	if (chr_xdir == -1)
		chr_hspeed = min(0, chr_hspeed);
}
chr_hspeed = clamp(chr_hspeed, -chr_hspeedMax, chr_hspeedMax);
chr_vspeed = clamp(chr_vspeed, -chr_vspeedMax, chr_vspeedMax);

//	Set Jump
if (key_jump && chr_jumpCount > 0)
{
	chr_vspeed = -chr_jumpPower;
	chr_jumpCount -= 1;
}

//	Horizontal Collision
repeat (abs(floor(chr_hspeed)))
{
    var chr_mov;
    chr_mov = false;
    if (place_meeting(x + chr_movDir, y, Block))
    {
		//	climb
        for (var i = 1; i <= chr_slopeMax; i++)
        {
            if (!place_meeting(x + chr_movDir, y - i, Block))
            {
                x += chr_movDir;
                y -= i;
                chr_mov = true;  
                break;
            }
        }
		//	Block
        if (chr_mov == false)
            chr_movDir = 0;

		//	Wall Jump
		if (chr_vspeed > 0 && !place_meeting(x, y - chr_vspeedMax, Block))
		{
			chr_vspeed /= 1.5;
			chr_jumpCount = chr_jumpCountMax;
		}
    }
	else
	{
		//	Down
        if (!place_meeting(x + chr_movDir, y + 1, Block) && place_meeting(x + chr_movDir, y + 2, Block))
        {
            x += chr_movDir; 
            y += 1;     
            chr_mov = true;
        }
		//	Straight
        if (chr_mov == false) 
            x += chr_movDir; 
    }
}

//	Vertical Collision
if (place_meeting(x, y + chr_vspeed, Block))
{
	while (!place_meeting(x, y + sign(chr_vspeed), Block))
		y += sign(chr_vspeed);
	chr_vspeed = 0;
}
y += chr_vspeed;

//	Jump Reset
if (place_meeting(x, y + 1, Block) && chr_vspeed == 0)
	chr_jumpCount = chr_jumpCountMax;
	
	
//if (place_meeting(x, y + 1, Bridge))
//{
//	x += Bridge.block_speed * Bridge.block_dir * 2;
//}
show_debug_message(string(chr_hspeed) + " " + string(chr_vspeed));