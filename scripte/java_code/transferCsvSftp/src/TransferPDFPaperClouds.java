/**
*
* Copyright (C) 2013-2013 Spaska Forteva
* Environmental Informatics
* University of Marburg
* Germany
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
* Please send any comments, suggestions, criticism, or (for our sake) bug
* reports to sforteva@yahoo.de
*
* http://environmentalinformatics-marburg.de
*/

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Formatter;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

/**
 * This class copy files from local to a remote computer with the given ip address. 
 * The run arguments are strings - 190.xxx.xxx.x  source destination directory
 * 
 * @version 0.1 2015-06-23
 * @author Spaska Forteva
 * 
 */
public class TransferPDFPaperClouds {

	/**
	 * main function
	 * 
	 * @param args - array from strings
	 */
	public static void main(String[] args) {
		TransferPDFPaperClouds ob = new TransferPDFPaperClouds();
		
		try {
			PrintStream errstr;
			errstr = new PrintStream(new FileOutputStream(
					args[1]+"error.log", true));
			String today = "=============================================================================\n"
					+ DateFormat.getDateTimeInstance(DateFormat.LONG,
							DateFormat.FULL).format(
									Calendar.getInstance().getTime()) + "\n\n";
			errstr.write(today.getBytes(), 0, today.length());
			System.setErr(errstr);

			//TransferSftp ob = new TransferSftp();
			JSch jsch = new JSch();
			Session session = null;
			ChannelSftp sftpChannel = null;
			session = jsch.getSession("u70863963-sforteva", args[0], 22);
			session.setConfig("StrictHostKeyChecking", "no");
			session.setPassword("25spacea");
			session.connect();
			Channel channel = session.openChannel("sftp");
			channel.connect();
			sftpChannel = (ChannelSftp) channel;
			sftpChannel.cd(args[2]);
			ob.copyFilesToServer( args[1], args[2], session, sftpChannel);
			channel.disconnect();
			sftpChannel.exit();
			session.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	private static String encryptPassword(String password)
	{
	    String sha1 = "";
	    try
	    {
	        MessageDigest crypt = MessageDigest.getInstance("SHA-1");
	        crypt.reset();
	        crypt.update(password.getBytes("UTF-8"));
	        sha1 = byteToHex(crypt.digest());
	    }
	    catch(NoSuchAlgorithmException e)
	    {
	        e.printStackTrace();
	    }
	    catch(UnsupportedEncodingException e)
	    {
	        e.printStackTrace();
	    }
	    return sha1;
	}
	private static String byteToHex(final byte[] hash)
	{
	    Formatter formatter = new Formatter();
	    for (byte b : hash)
	    {
	        formatter.format("%02x", b);
	    }
	    String result = formatter.toString();
	    formatter.close();
	    return result;
	}
	/**
	 * This Method copies the csv-Files to the servers with the given ip address
	 * 
	 * @param hostIP host
	 * @param destDir directory to copy
	 * @param scrDir source file directory
	 * @param fileName file name
	 */
	public void copyFilesToServer( String scrDir,String destDir,
			Session session, ChannelSftp sftpChannel) {

		try {
			File file = new File(scrDir);
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				for (int i = 0; i < files.length; i++) {
					if (files[i].isFile()) {
						String sourPath = files[i].getAbsolutePath();
						sftpChannel.put(sourPath, destDir);
					} else {
						try {
							sftpChannel.mkdir(destDir + "/"
									+ files[i].getName());
							copyFilesToServer(
									destDir + "/" + files[i].getName(),
									files[i].getAbsolutePath(), session,
									sftpChannel);

						} catch (SftpException esft) {
							esft.printStackTrace();
							copyFilesToServer(
									destDir + "/" + files[i].getName(),
									files[i].getAbsolutePath(), session,
									sftpChannel);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();

		}
	}

}
