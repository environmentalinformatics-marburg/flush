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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.swing.JOptionPane;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;

/**
 * This class copy files from local to a remote computer with the given ip address. 
 * The run arguments are strings - 190.xxx.xxx.x  source destination directory
 * 
 * @version 0.1 2015-06-23
 * @author Spaska Forteva
 * 
 */
public class TransferADLM_Logs {

	/**
	 * main function
	 * 
	 * @param args - array from strings
	 */
	public static void main(String[] args) {
		TransferADLM_Logs ob = new TransferADLM_Logs();
		
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
			//AuthUserLogin a = new AuthUserLogin();
			//a.setVisible(true);
			String pass = "porov*tsdb!";
			String user = "tsdb";
			//TransferSftp ob = new TransferSftp();
			JSch jsch = new JSch();
			Session session = null;
			ChannelSftp sftpChannel = null;
			session = jsch.getSession(user, args[0], 22); //u70863963-sforteva
			session.setConfig("StrictHostKeyChecking", "no");
			session.setPassword(pass);
			session.connect();
			//a.dispose();
			Channel channel = session.openChannel("sftp");
			channel.connect();
			errstr.write("Connect ok".getBytes(), 0, "Connect ok".length());
			System.setErr(errstr);
			sftpChannel = (ChannelSftp) channel;
			sftpChannel.cd(args[2]);
			ob.copyFilesToServer( args[1], args[2], session, sftpChannel);
			channel.disconnect();
			sftpChannel.exit();
			session.disconnect();
		}
		  catch (JSchException e2) {
			  JOptionPane.showMessageDialog(null, "Passwort oder Username nicht korrekt!", "Error", JOptionPane.ERROR_MESSAGE); 
		}
		 catch (Exception e) {
				e.printStackTrace();
		}

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
			SimpleDateFormat sdfmt = new SimpleDateFormat();
			sdfmt.applyPattern( "yyyyMMdd" );
			System.out.println( sdfmt.format(new Date()) );
			File file = new File(scrDir);
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				for (int i = 0; i < files.length; i++) {
					if (files[i].isDirectory()) {
					try {
						String destDirTemp = destDir +  files[i].getName();
						
						try {
							SftpATTRS attrs=null;
						    attrs = sftpChannel.stat(destDirTemp);
						} catch (Exception e) {
							sftpChannel.mkdir(destDirTemp);
						}
							
						String sourPath = files[i].getAbsolutePath() + "/#actual.sta";
						sftpChannel.put(sourPath, destDirTemp + "/" + sdfmt.format(new Date())+ "_actual.sta");
						} catch (SftpException esft) {
							esft.printStackTrace();
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();

		}
	}

}
