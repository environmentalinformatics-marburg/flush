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
import java.util.Collection;
import java.util.Formatter;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

import javax.swing.JList;
/**
 * This class copy csv-files from local to a remote computer with the given ip address. 
 * The run arguments are strings - 190.xxx.xxx.x destinationdirectory sourcedirectory
 * 
 * @version 0.1 2014-05-14
 * @author Spaska Forteva
 * 
 */
public class TransferADLM {

	/**
	 * main function
	 * 
	 * @param args - array from strings
	 */
	public static void main(String[] args) 
	{
	    JFrame frame = new JFrame("Start Backup");
	    TransferADLM  adm= new TransferADLM();
	    ConfigSftp conf = ConfigSftp.getInstance("sftptransfer.properties");
		PrintStream errstr;
		
	    // prompt the user to enter their name and password for the backup
		// get the user's input. note that if they press Cancel, 'name' will be null
	    String name = JOptionPane.showInputDialog(frame, "Name");
	    JPasswordField pwd = new JPasswordField(10); 
	    JOptionPane.showConfirmDialog(null, pwd, "Enter Password", JOptionPane.OK_CANCEL_OPTION); 
	    String pass = new String(pwd.getPassword());
        if ((name!="" && name != null) && (pass!="" && pass != null)){
        	
			String []ipadrs = conf.get("ipAdrs").split(" ");
			String []destPaths = conf.get("sftpDestPaths").split(" ");
			String []scrPaths = conf.get("sftpScrPaths").split(" ");
			String []stations = conf.get("stations").split(" ");

			try {
				// Writing into error file
				errstr = new PrintStream(new FileOutputStream(
						conf.get("errorLog") + "error.log", true));
				String today = "=============================================================================\n"
						+ DateFormat.getDateTimeInstance(DateFormat.LONG,
								DateFormat.FULL).format(
										Calendar.getInstance().getTime()) + "\n\n";
				errstr.write(today.getBytes(), 0, today.length());
				System.setErr(errstr);
				for (int i = 0; i< ipadrs.length; i++) {
					JSch jsch = new JSch();
					Session session = null;
					ChannelSftp sftpChannel = null;
					session = jsch.getSession(name, ipadrs[i], 22);
					session.setConfig("StrictHostKeyChecking", "no");
					session.setPassword(pass);
					session.connect();
					Channel channel = session.openChannel("sftp");
					channel.connect();
					sftpChannel = (ChannelSftp) channel;
					sftpChannel.cd(destPaths[i]);
					
					for ( int s = 0; s < stations.length; s++){
						adm.copyFilesToServer( destPaths[i] + stations[s], scrPaths[i] + stations[s], session, sftpChannel);
					}
					channel.disconnect();
					sftpChannel.exit();
					session.disconnect();
				}

				if(conf.get( "locDestPath" ) !=""){
					adm.moveToProcessing(conf.get( "locDestPath" ), conf.get( "locScrPath" ), stations, errstr);
					JOptionPane.showMessageDialog(null,
			                "The extern backup completes successfully!",
			                "Message",
			                JOptionPane.INFORMATION_MESSAGE);
				}
				
			} catch(JSchException eJS){
				eJS.printStackTrace();
				int res = JOptionPane.showConfirmDialog(null, "Es sind Fehler bei der Übertragung aufgetretten. S" +
						"chauen Sie bitte in den Error-Log File?", "Fehler",
		                JOptionPane.YES_NO_OPTION);
				if(res==JOptionPane.YES_OPTION){ 
					adm.main(args);
				} else {
					System.exit(0);
				}
			}
			catch (Exception e) {
				e.printStackTrace();
				int res = JOptionPane.showConfirmDialog(null, "Username oder Passwort sind nicht korrekt. " +
						"Versuchen Sie noch ein Mal?", "Bestätigung",
		                JOptionPane.YES_NO_OPTION);
				if(res==JOptionPane.YES_OPTION){ 
					adm.main(args);
				} else {
					System.exit(0);
				}
			}	
		}
        
        System.exit(0);
	}
	
	/**
	 * This method copies the csv-Files to the servers with the given ip address
	 * 
	 * @param destDir directory to copy
	 * @param scrDir source file directory
	 * @param session the user session
	 * @param sftpChanel sftp channel with the given ip address
	 */
	public void copyFilesToServer(String destDir, String scrDir,
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
			JOptionPane.showMessageDialog(null,
	                e.toString(),
	                "Message",
	                JOptionPane.INFORMATION_MESSAGE);

		}
	}
			
	/**
	 * This method moves the files local from to the the given directory
	 * @param destDir
	 * @param scrDir
	 * @param stations HEG HEW SEG SEW AEG AEW AET SET JIG
	 */
	private void moveToProcessing(String destDir, String scrDir, String [] stations, PrintStream errstr)
	{   
        try {
		    for (String station: stations) {
				File fileToBeMoved = new File(scrDir+station);
			    File [] list = fileToBeMoved.listFiles();
			    for ( File file: list){
					    File newFileName = new File(destDir + station + "/" + file.getName());
					    File dir = new File(destDir + station);
						if ( !dir.exists()) {
							dir.mkdir();
						}
					    boolean isMoved = file.renameTo(newFileName);
					    if(isMoved) {
					        System.out.println("File moved successfully");
					        errstr.write("File moved successfully".getBytes(), 0, "File moved successfully".length());
					    }
					    else {
					    	JOptionPane.showMessageDialog(null,
					    			"File could not be moved",
					                "Message",
					                JOptionPane.INFORMATION_MESSAGE);
					    	errstr.write("Error: File could not be moved".getBytes(), 0, "Error: File could not be moved".length());
					   }
			    }
		    }
        }
        catch(Exception e) {
        	e.printStackTrace();
			JOptionPane.showMessageDialog(null,
	                e.toString(),
	                "Message",
	                JOptionPane.INFORMATION_MESSAGE);
        }
	}
	
	/**
	 * 
	 * @param password
	 * @return
	 */
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
	
	/**
	 * 
	 * @param hash
	 * @return
	 */
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


}
