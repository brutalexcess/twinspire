/**
Twinspire Editor is an application that enables video game development on-the-fly.
Copyright (C) 2015 Colour Multimedia Enterprises

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package;

import hscript.Interp;
import hscript.Parser;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import sys.FileStat;
import sys.FileSystem;
import sys.io.File;

class Main extends Sprite 
{
	
	private var timeLoaded:Date;
	private var _gen:Generator;
	private var _interp:Interp;
	private var _parser:Parser;
	private var _classes:String;
	private var _enums:String;
	private var _scenes:Array<Sprite> = [];
		
	public function new() 
	{
		super();

		_interp = new Interp();
		_parser = new Parser();
		
		_parser.allowJSON = true;
		_parser.allowTypes = true;
		
		_classes = File.getContent("info/openflClasses.txt");
		_enums = File.getContent("info/openflEnums.txt");
		
		for (item in _classes.split(";"))
			_interp.variables.set(item, Type.resolveClass(item));
		
		for (item in _enums.split(";"))
			_interp.variables.set(item, Type.resolveEnum(item));
			
		
		
		timeLoaded = FileSystem.stat("info/game.json").mtime;
		_gen = new Generator("info/game.json", _interp, _parser);
		
		addEventListener(Event.ENTER_FRAME, load);
		
	}
	
	private function getScene(name:String):Sprite
	{
		var scenes = _gen.getScenes();
		for (i in 0...scenes.length)
		{
			if (scenes[i].name == name)
				return scenes[i];
		}
		return null;
	}
	
	private function getLayer(index:Int, scene:Sprite):Sprite
	{
		
	}
	
	private function load(e:Event)
	{
		if (FileSystem.exists("info/game.json"))
		{
			var fi = FileSystem.stat("info/game.json");
			if (fi.mtime.getTime() > timeLoaded.getTime())
			{
				_gen.refresh();
				
				timeLoaded = fi.mtime;
			}
		}
	}
	
}
