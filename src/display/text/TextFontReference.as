package display.text {
	import flash.text.Font;
	
	/**
	 * The TextFontReference Class contains a list of font names that the Flash player might be able to parse when using system fonts alongside the Text class, you can use this class to find a font you want to use if you aren't using embedded fonts
	 * @author Alec Spillman
	 */
	public class TextFontReference {
		public static const ADOBE_ARABIC:String = "Adobe Arabic";
		public static const ADOBE_CASLON_PRO:String = "Adobe Caslon Pro";
		public static const ADOBE_CASLON_PRO_BOLD:String = "Adobe Caslon Pro Bold";
		public static const ADOBE_DEVANAGARI:String = "Adobe Devanagari";
		public static const ADOBE_FAN_HEITI_STD_B:String = "Adobe Fan Heiti Std B";
		public static const ADOBE_FANGSONG_STD_R:String = "Adobe Fangsong Std R";
		public static const ADOBE_GARAMOND_PRO:String = "Adobe Garamond Pro";
		public static const ADOBE_GARAMOND_PRO_BOLD:String = "Adobe Garamond Pro Bold";
		public static const ADOBE_GOTHIC_STD_B:String = "Adobe Gothic Std B";
		public static const ADOBE_GURMUKHI:String = "Adobe Gurmukhi";
		public static const ADOBE_HEBREW:String = "Adobe Hebrew";
		public static const ADOBE_HEITI_STD_R:String = "Adobe Heiti Std R";
		public static const ADOBE_KAITI_STD_R:String = "Adobe Kaiti Std R";
		public static const ADOBE_MING_STD_L:String = "Adobe Ming Std L";
		public static const ADOBE_MYUNGJO_STD_M:String = "Adobe Myungjo Std M";
		public static const ADOBE_NASKH_MEDIUM:String = "Adobe Naskh Medium";
		public static const ADOBE_SONG_STD_L:String = "Adobe Song Std L";
		public static const ARABIC_TRANSPARENT:String = "Arabic Transparent";
		public static const ARIAL:String = "Arial";
		public static const ARIAL_BALTIC:String = "Arial Baltic";
		public static const ARIAL_BLACK:String = "Arial Black";
		public static const ARIAL_CE:String = "Arial CE";
		public static const ARIAL_CYR:String = "Arial CYR";
		public static const ARIAL_GREEK:String = "Arial Greek";
		public static const ARIAL_TUR:String = "Arial TUR";
		public static const BIRCH_STD:String = "Birch Std";
		public static const BLACKOAK_STD:String = "Blackoak Std";
		public static const BRUSH_SCRIPT_STD:String = "Brush Script Std";
		public static const CALIBRI:String = "Calibri";
		public static const CALIBRI_LIGHT:String = "Calibri Light";
		public static const CAMBRIA:String = "Cambria";
		public static const CAMBRIA_MATH:String = "Cambria Math";
		public static const CANDARA:String = "Candara";
		public static const CHAPARRAL_PRO:String = "Chaparral Pro";
		public static const CHAPARRAL_PRO_LIGHT:String = "Chaparral Pro Light";
		public static const CHARLEMAGNE_STD:String = "Charlemagne Std";
		public static const COMIC_SANS_MS:String = "Comic Sans MS";
		public static const CONSOLAS:String = "Consolas";
		public static const CONSTANTIA:String = "Constantia";
		public static const CORBEL:String = "Corbel";
		public static const COURIER_NEW:String = "Courier New";
		public static const COURIER_NEW_BALTIC:String = "Courier New Baltic";
		public static const COURIER_NEW_CE:String = "Courier New CE";
		public static const COURIER_NEW_CYR:String = "Courier New CYR";
		public static const COURIER_NEW_GREEK:String = "Courier New Greek";
		public static const COURIER_NEW_TUR:String = "Courier New TUR";
		public static const EBRIMA:String = "Ebrima";
		public static const FRANKLIN_GOTHIC_MEDIUM:String = "Franklin Gothic Medium";
		public static const GABRIOLA:String = "Gabriola";
		public static const GADUGI:String = "Gadugi";
		public static const GEORGIA:String = "Georgia";
		public static const HOBO_STD:String = "Hobo Std";
		public static const IMPACT:String = "Impact";
		public static const JAVANESE_TEXT:String = "Javanese Text";
		public static const KOZUKA_GOTHIC_PR6N_B:String = "Kozuka Gothic Pr6N B";
		public static const KOZUKA_GOTHIC_PR6N_EL:String = "Kozuka Gothic Pr6N EL";
		public static const KOZUKA_GOTHIC_PR6N_H:String = "Kozuka Gothic Pr6N H";
		public static const KOZUKA_GOTHIC_PR6N_L:String = "Kozuka Gothic Pr6N L";
		public static const KOZUKA_GOTHIC_PR6N_M:String = "Kozuka Gothic Pr6N M";
		public static const KOZUKA_GOTHIC_PR6N_R:String = "Kozuka Gothic Pr6N R";
		public static const KOZUKA_GOTHIC_PRO_B:String = "Kozuka Gothic Pro B";
		public static const KOZUKA_GOTHIC_PRO_EL:String = "Kozuka Gothic Pro EL";
		public static const KOZUKA_GOTHIC_PRO_H:String = "Kozuka Gothic Pro H";
		public static const KOZUKA_GOTHIC_PRO_L:String = "Kozuka Gothic Pro L";
		public static const KOZUKA_GOTHIC_PRO_M:String = "Kozuka Gothic Pro M";
		public static const KOZUKA_GOTHIC_PRO_R:String = "Kozuka Gothic Pro R";
		public static const KOZUKA_MINCHO_PR6N_B:String = "Kozuka Mincho Pr6N B";
		public static const KOZUKA_MINCHO_PR6N_EL:String = "Kozuka Mincho Pr6N EL";
		public static const KOZUKA_MINCHO_PR6N_H:String = "Kozuka Mincho Pr6N H";
		public static const KOZUKA_MINCHO_PR6N_L:String = "Kozuka Mincho Pr6N L";
		public static const KOZUKA_MINCHO_PR6N_M:String = "Kozuka Mincho Pr6N M";
		public static const KOZUKA_MINCHO_PR6N_R:String = "Kozuka Mincho Pr6N R";
		public static const KOZUKA_MINCHO_PRO_B:String = "Kozuka Mincho Pro B";
		public static const KOZUKA_MINCHO_PRO_EL:String = "Kozuka Mincho Pro EL";
		public static const KOZUKA_MINCHO_PRO_H:String = "Kozuka Mincho Pro H";
		public static const KOZUKA_MINCHO_PRO_L:String = "Kozuka Mincho Pro L";
		public static const KOZUKA_MINCHO_PRO_M:String = "Kozuka Mincho Pro M";
		public static const KOZUKA_MINCHO_PRO_R:String = "Kozuka Mincho Pro R";
		public static const LEELAWADEE_UI:String = "Leelawadee UI";
		public static const LEELAWADEE_UI_SEMILIGHT:String = "Leelawadee UI Semilight";
		public static const LETTER_GOTHIC_STD:String = "Letter Gothic Std";
		public static const LITHOS_PRO_REGULAR:String = "Lithos Pro Regular";
		public static const LUCIDA_CONSOLE:String = "Lucida Console";
		public static const LUCIDA_SANS_UNICODE:String = "Lucida Sans Unicode";
		public static const MALGUN_GOTHIC:String = "Malgun Gothic";
		public static const MALGUN_GOTHIC_SEMILIGHT:String = "Malgun Gothic Semilight";
		public static const MARLETT:String = "Marlett";
		public static const MICROSOFT_HIMALAYA:String = "Microsoft Himalaya";
		public static const MICROSOFT_JHENGHEI:String = "Microsoft JhengHei";
		public static const MICROSOFT_JHENGHEI_LIGHT:String = "Microsoft JhengHei Light";
		public static const MICROSOFT_JHENGHEI_UI:String = "Microsoft JhengHei UI";
		public static const MICROSOFT_JHENGHEI_UI_LIGHT:String = "Microsoft JhengHei UI Light";
		public static const MICROSOFT_NEW_TAI_LUE:String = "Microsoft New Tai Lue";
		public static const MICROSOFT_PHAGSPA:String = "Microsoft PhagsPa";
		public static const MICROSOFT_SANS_SERIF:String = "Microsoft Sans Serif";
		public static const MICROSOFT_TAI_LE:String = "Microsoft Tai Le";
		public static const MICROSOFT_YAHEI:String = "Microsoft YaHei";
		public static const MICROSOFT_YAHEI_LIGHT:String = "Microsoft YaHei Light";
		public static const MICROSOFT_YAHEI_UI:String = "Microsoft YaHei UI";
		public static const MICROSOFT_YAHEI_UI_LIGHT:String = "Microsoft YaHei UI Light";
		public static const MICROSOFT_YI_BAITI:String = "Microsoft Yi Baiti";
		public static const MINGLIU_EXTB:String = "MingLiU-ExtB";
		public static const MINGLIU_HKSCS_EXTB:String = "MingLiU_HKSCS-ExtB";
		public static const MINION_PRO:String = "Minion Pro";
		public static const MINION_PRO_COND:String = "Minion Pro Cond";
		public static const MINION_PRO_MED:String = "Minion Pro Med";
		public static const MINION_PRO_SMBD:String = "Minion Pro SmBd";
		public static const MONGOLIAN_BAITI:String = "Mongolian Baiti";
		public static const MS_GOTHIC:String = "MS Gothic";
		public static const MS_PGOTHIC:String = "MS PGothic";
		public static const MS_UI_GOTHIC:String = "MS UI Gothic";
		public static const MV_BOLI:String = "MV Boli";
		public static const MYANMAR_TEXT:String = "Myanmar Text";
		public static const MYRIAD_ARABIC:String = "Myriad Arabic";
		public static const MYRIAD_HEBREW:String = "Myriad Hebrew";
		public static const MYRIAD_PRO:String = "Myriad Pro";
		public static const MYRIAD_PRO_COND:String = "Myriad Pro Cond";
		public static const MYRIAD_PRO_LIGHT:String = "Myriad Pro Light";
		public static const NIRMALA_UI:String = "Nirmala UI";
		public static const NIRMALA_UI_SEMILIGHT:String = "Nirmala UI Semilight";
		public static const NSIMSUN:String = "NSimSun";
		public static const NUEVA_STD:String = "Nueva Std";
		public static const NUEVA_STD_COND:String = "Nueva Std Cond";
		public static const OCR_A_STD:String = "OCR A Std";
		public static const ORATOR_STD:String = "Orator Std";
		public static const PALATINO_LINOTYPE:String = "Palatino Linotype";
		public static const PMINGLIU_EXTB:String = "PMingLiU-ExtB";
		public static const POPLAR_STD:String = "Poplar Std";
		public static const PRESTIGE_ELITE_STD:String = "Prestige Elite Std";
		public static const SEGOE_MDL2_ASSETS:String = "Segoe MDL2 Assets";
		public static const SEGOE_PRINT:String = "Segoe Print";
		public static const SEGOE_SCRIPT:String = "Segoe Script";
		public static const SEGOE_UI:String = "Segoe UI";
		public static const SEGOE_UI_BLACK:String = "Segoe UI Black";
		public static const SEGOE_UI_EMOJI:String = "Segoe UI Emoji";
		public static const SEGOE_UI_HISTORIC:String = "Segoe UI Historic";
		public static const SEGOE_UI_LIGHT:String = "Segoe UI Light";
		public static const SEGOE_UI_SEMIBOLD:String = "Segoe UI Semibold";
		public static const SEGOE_UI_SEMILIGHT:String = "Segoe UI Semilight";
		public static const SEGOE_UI_SYMBOL:String = "Segoe UI Symbol";
		public static const SIMSUN:String = "SimSun";
		public static const SIMSUN_EXTB:String = "SimSun-ExtB";
		public static const SITKA_BANNER:String = "Sitka Banner";
		public static const SITKA_DISPLAY:String = "Sitka Display";
		public static const SITKA_HEADING:String = "Sitka Heading";
		public static const SITKA_SMALL:String = "Sitka Small";
		public static const SITKA_SUBHEADING:String = "Sitka Subheading";
		public static const SITKA_TEXT:String = "Sitka Text";
		public static const SOURCE_SANS_PRO:String = "Source Sans Pro";
		public static const SOURCE_SANS_PRO_BLACK:String = "Source Sans Pro Black";
		public static const SOURCE_SANS_PRO_EXTRALIGHT:String = "Source Sans Pro ExtraLight";
		public static const SOURCE_SANS_PRO_LIGHT:String = "Source Sans Pro Light";
		public static const SOURCE_SANS_PRO_SEMIBOLD:String = "Source Sans Pro Semibold";
		public static const SYLFAEN:String = "Sylfaen";
		public static const SYMBOL:String = "Symbol";
		public static const TAHOMA:String = "Tahoma";
		public static const TEKTON_PRO:String = "Tekton Pro";
		public static const TEKTON_PRO_COND:String = "Tekton Pro Cond";
		public static const TEKTON_PRO_EXT:String = "Tekton Pro Ext";
		public static const TIMES_NEW_ROMAN:String = "Times New Roman";
		public static const TIMES_NEW_ROMAN_BALTIC:String = "Times New Roman Baltic";
		public static const TIMES_NEW_ROMAN_CE:String = "Times New Roman CE";
		public static const TIMES_NEW_ROMAN_CYR:String = "Times New Roman CYR";
		public static const TIMES_NEW_ROMAN_GREEK:String = "Times New Roman Greek";
		public static const TIMES_NEW_ROMAN_TUR:String = "Times New Roman TUR";
		public static const TRAJAN_PRO_3:String = "Trajan Pro 3";
		public static const TREBUCHET_MS:String = "Trebuchet MS";
		public static const VERDANA:String = "Verdana";
		public static const WEBDINGS:String = "Webdings";
		public static const WINGDINGS:String = "Wingdings";
		public static const YU_GOTHIC:String = "Yu Gothic";
		public static const YU_GOTHIC_LIGHT:String = "Yu Gothic Light";
		public static const YU_GOTHIC_MEDIUM:String = "Yu Gothic Medium";
		public static const YU_GOTHIC_UI:String = "Yu Gothic UI";
		public static const YU_GOTHIC_UI_LIGHT:String = "Yu Gothic UI Light";
		public static const YU_GOTHIC_UI_SEMIBOLD:String = "Yu Gothic UI Semibold";
		public static const YU_GOTHIC_UI_SEMILIGHT:String = "Yu Gothic UI Semilight";
		
		
		/**
		 * Traces every found system font, useful if you're trying to apply dynamic font into a program and want to see your options since each system is different in which fonts they support
		 * @param	traceWholeDefinition True to trace lines of definitions you can easily copy and paste into the TextFontReference class to use immediately. For instance for the font Times New Roman that trace line would be 'public static const TIMES_NEW_ROMAN:String = "Times New Roman";'. If false this method only traces each font name, like "Times New Roman"
		 */
		public static function traceSystemFonts(traceWholeDefinition:Boolean = true):void {
			var fontArray:Array = Font.enumerateFonts(true);
			
			for (var i:uint = 0; i < fontArray.length; i++) {
				var currentFont:String = Font(fontArray[i]).fontName;
				
				if (traceWholeDefinition) {
					var fontSplit:String = currentFont;
					fontSplit = currentFont.split(" ").join("_");
					fontSplit = fontSplit.split("-").join("_");
					trace("public static const " + fontSplit.toUpperCase() + ':String = "' + currentFont + '";');
				}
				else trace(currentFont);
			}
		}
	}
}