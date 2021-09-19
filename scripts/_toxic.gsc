#include scripts\_lurkzy_utility;

init() {}


initmenu()
{
    self.menu = spawnStruct();
    self.hud = spawnStruct();
    self.menu.isOpen = false;
    self thread menu();
    self thread buttons();
}

loadMenu(menu)
{
    self.menu.savedPos[self.menu.current] = self.scroller;
    destroyMenuText();
    self.menu.current = menu;

    if(isDefined(self.menu.savedPos[menu]))
        self.scroller = self.menu.savedPos[menu];
    else
        self.scroller = 0;

    buildMenuText();
    updatescroll();
}

buildMenuText()
{
    for(i=0;i<self.menu.text[self.menu.current].size;i++)
    {
        self.hud.text[i] = createTextElem("default", 1.6, "LEFT", "CENTER", 100, -110 + (20 * i), 1, (1, 1, 1), 1, (0, 0, 0), 0, self.menu.text[self.menu.current][i]);
        self.hud.text[i].foreground = true;
    }
}

destroyMenuText()
{
    if(isDefined(self.hud.text))
    {
        for(i=0;i<self.hud.text.size;i++)
            self.hud.text[i] destroy();
    }
}

destroyHud()
{
    self.hud.title destroy();
    self.hud.credits destroy();
    self.hud.optionCount destroy();
    self.hud.leftBar destroy();
    self.hud.rightBar destroy();
    self.hud.topBar destroy();
    self.hud.topSeparator destroy();
    self.hud.bottomSeparator destroy();
    self.hud.bottomBar destroy();
    self.hud.scroller destroy();
    self.hud.background destroy();
}

updatescroll()
{
    if(self.Scroller < 0)
        self.Scroller = self.menu.text[self.menu.current].size - 1;
    if(self.Scroller > self.menu.text[self.menu.current].size - 1)
        self.Scroller = 0;

    self.hud.optionCount setText("" + (self.scroller + 1) + "/" + self.menu.text[self.menu.current].size + "");
    self.hud.scroller.y = -108 + ( 20 * self.Scroller);
}

buildhud()
{
    if(!isDefined(self.theme))
        self.theme = (0.439, 0.804, 0.196); // default theme color
        
    self.hud.title = createTextElem("default", 2.1, "CENTER", "CENTER", 200, -160, 1, (1, 1, 1), 1, self.theme, .7, "Menu Base"); // title
    self.hud.title.foreground = true;

    self.hud.credits = createTextElem("default", 0.9, "CENTER", "CENTER", 115, 165, 1, (1, 1, 1), .7, (0, 0, 0), 0, "by @Lurkzy"); // credits
    self.hud.credits.foreground = true;

    self.hud.optionCount = createTextElem("default", 1, "CENTER", "CENTER", 288, -130, 1, (1, 1, 1), .7, (0, 0, 0), 0, ""+(self.scroller + 1) + "/" + self.menu.text[self.menu.current].size+""); // option count
    self.hud.optionCount.foreground = true;

    self.hud.leftBar = createBarElem("CENTER", "CENTER", 95, 0, 1, 350, self.theme, 1, 1, "white"); // left bar
    self.hud.rightBar = createBarElem("CENTER", "CENTER", 305, 0, 1, 350, self.theme, 1, 1, "white"); // right bar

    self.hud.topBar = createBarElem("CENTER", "CENTER", 200, -175, 210, 1, self.theme, 1, 1, "white"); // top bar
    self.hud.topSeparator = createBarElem("CENTER", "CENTER", 200, -135, 210, 1, self.theme, 1, 1, "white"); // top separator

    self.hud.bottomBar = createBarElem("CENTER", "CENTER", 200, 175, 210, 1, self.theme, 1, 1, "white"); // bottom bar 
    self.hud.bottomSeparator = createBarElem("CENTER", "CENTER", 200, 160, 210, 1, self.theme, 1, 1, "white"); // bottom separator

    self.hud.scroller = createBarElem("CENTER", "CENTER", 200, -28, 210, 15, self.theme, 1, 1, "white"); // scroller
    self.hud.background = createBarElem("CENTER", "CENTER", 200, 0, 210, 350, (0, 0, 0), .87, 0, "white"); // background
}


addNewOption(menu, index, name, function, argument)
{
    self.menu.text[menu][index] = name;
    self.menu.function[menu][index] = function;
    self.menu.argument[menu][index] = argument;
}

addNewMenu(menu, parent)
{
    self.menu.parent[menu] = parent;
}

menu()
{
    addNewMenu("main", "exit");
    addNewOption("main", 0, "Palceholder",                  ::Test,"");
    addNewOption("main", 1, "Palceholder",                  ::Test,"");
    addNewOption("main", 2, "Palceholder",                  ::Test,"");
    addNewOption("main", 3, "Palceholder",                  ::Test,"");
    addNewOption("main", 4, "Palceholder",                  ::Test,"");
    addNewOption("main", 5, "Palceholder",                  ::Test,"");
    addNewOption("main", 6, "Palceholder",                  ::Test,"");
    addNewOption("main", 7, "Palceholder",                  ::Test,"");
    addNewOption("main", 8, "Palceholder",                  ::Test,"");
    addNewOption("main", 9, "Palceholder",                  ::Test,"");
}

buttons()
{
    self endon("disconnect");

    self notifyOnPlayerCommand("menu_open", "+actionslot 1");
    for(;;)
    {
        if(!self.menu.isOpen)
        {
            if(self adsbuttonpressed())
            {
                self waittill("menu_open");

                self thread buildHud();
                self thread doMenuUp(); 
                self thread doMenuDown();   
                self loadMenu("main");
                self.menu.isOpen = true;
                wait .2;
            }
        }
        else
        {
            if(self usebuttonpressed())
            {
                self thread [[self.menu.function[self.menu.current][self.scroller]]](self.menu.argument[self.menu.current][self.scroller]);
                wait .2;
            }
            if(self meleebuttonpressed())
            {
                if(self.menu.parent[self.menu.current] == "exit")
                {
                    destroyHud();
                    destroyMenuText();
                    self.menu.isOpen = false;
                    self notify("stopmenu_up");
                    self notify("stopmenu_down");
                    wait .2;
                }
                else
                {
                    loadMenu(self.menu.parent[self.menu.current]);
                    wait .2;
                }
            }
        }

        wait .1;
    }
}

watchDeath()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill("death");
        
        if(self.menu.isOpen)
        {
            destroyHud();
            destroyMenuText();
            self.menu.isOpen = false;
            self notify("stopmenu_up");
            self notify("stopmenu_down");
        }

        wait .1;
    }
}

doMenuUp()
{
    self endon("disconnect");
    self endon("stopmenu_up");

    self notifyOnPlayerCommand("menu_up", "+actionslot 1");
    for(;;)
    {
        
        self waittill("menu_up");
        self.scroller--;
        self updatescroll();
        wait .2;
    }
}

doMenuDown()
{
    self endon("disconnect");
    self endon("stopmenu_down");

    self notifyOnPlayerCommand("menu_down", "+actionslot 2");
    for(;;)
    {
        
        self waittill("menu_down");
        self.scroller++;
        self updatescroll();
        wait .2;
    }
}