package com.ethan.utils;


import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {

	public static String formatDate(Date date,String format){
		String result="";
		SimpleDateFormat sdf=new SimpleDateFormat(format);
		if(date!=null){
			result=sdf.format(date);
		}
		return result;
	}
	
	
	public static Date formatString(String str,String format) throws Exception{
		SimpleDateFormat sdf=new SimpleDateFormat(format);
		return sdf.parse(str);
	}

	public static Date addDate(Date date, long day) {
		long time = date.getTime();
		day = day * 24 * 60 * 60 * 1000;
		time += day;
		return new Date(time);
	}

	public static long getDays(Date dueDate, Date expireDate) {
		long dueTime = dueDate.getTime();
		long expireTime = expireDate.getTime();

//		if ()
		long days = (dueTime - expireTime) / 1000 / 60 / 60 / 24;


//		day = day*24*60*60*1000;
//		time += day;
		return days;
	}
}
