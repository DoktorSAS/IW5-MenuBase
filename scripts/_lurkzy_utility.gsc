#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init() {}

test()
{
    self iprintln("Script Sucesssful: [ ^2Test ^7]");
}

changeTheme( color )
{
    self.hud.title.glowColor = color;
    self.hud.title fadeOverTime(3);

    self.hud.leftBar.color = color;
    self.hud.leftBar fadeOverTime(3);

    self.hud.rightBar.color = color;
    self.hud.rightBar fadeOverTime(3);

    self.hud.topBar.color = color;
    self.hud.topBar fadeOverTime(3);

    self.hud.topSeparator.color = color;
    self.hud.topSeparator fadeOverTime(3);

    self.hud.bottomSeparator.color = color;
    self.hud.bottomSeparator fadeOverTime(3);

    self.hud.bottomBar.color = color;
    self.hud.bottomBar fadeOverTime(3);

    self.hud.scroller.color = color;
    self.hud.scroller fadeOverTime(3);
    
    self.theme = color;
}

createTextElem(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
    fontElem = CreateFontString( font, fontscale );
    fontElem setPoint( align, relative, x, y );
    fontElem.sort = sort;
    fontElem.type = "text";
    fontElem setText(text);
    fontElem.color = color;
    fontElem.alpha = alpha;
    fontElem.glowColor = glowColor;
    fontElem.glowAlpha = glowAlpha;
    fontElem.hideWhenInMenu = true;
    return fontElem;
}

createBarElem(align, relative, x, y, width, height, color, alpha, sort, shader)
{
    barElemBG = newClientHudElem( self );
    barElemBG.elemType = "bar";
    if ( !level.splitScreen )
    {
        barElemBG.x = -2;
        barElemBG.y = -2;
    }
    barElemBG.width = width;
    barElemBG.height = height;
    barElemBG.align = align;
    barElemBG.relative = relative;
    barElemBG.xOffset = 0;
    barElemBG.yOffset = 0;
    barElemBG.children = [];
    barElemBG.color = color;
    barElemBG.alpha = alpha;
    barElemBG setShader( shader, width , height );
    barElemBG.hidden = false;
    barElemBG.sort = sort;
    barElemBG setPoint(align, relative, x, y);
    return barElemBG;
}

abortForfeit()
{
    self endon("disconnect");
    for(;;)
    {
        if(isDefined(level.forfeitInProgress) && level.forfeitInProgress == true)
            level notify("abort_forfeit");

        wait .1;
    }
}

vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

getOtherTeam(team)
{
	if ( team == "axis" )
		return "allies";
	else if ( team == "allies" )
		return "axis";
	else
		return "none";
}
