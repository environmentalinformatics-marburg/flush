

import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;



/* Version $Rev: 655 $ */

/**
 * 
 * @author s.forteva
 * Created a user login dialog
 *
 */
public class AuthUserLogin extends JDialog implements ActionListener {

	@Override
	public void setVisible(boolean b) {
		super.setVisible(b);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 7727753851556468141L;
	/**
	 * Define user parameter
	 */
	
	//version 
	protected JLabel versionLabel;
	static String version = "$Rev:611 $";
	//private String final long serialVersionUID =  ;
	protected JTextField username;
	protected JPasswordField password;
	
	public JLabel usernameText;
	public JLabel passwordText;
	protected JButton cb;
	protected JButton lb;
	boolean rebuilding=false;
	protected JPanel bp;	//panel
	
	private boolean isOk = false;
	protected int countTrials=0;
	
	
	public AuthUserLogin(){
		super();
		setIconImage(Toolkit.getDefaultToolkit().getImage(getClass().getResource("")));
		
		Dimension screen=Toolkit.getDefaultToolkit().getScreenSize();
		int dialogWidth=600, dialogHeight=300;
		this.setLayout(null);
		this.setModal(true);
		int sw=screen.width,sh=screen.height;
		if (sw/sh>=2) {
			sw=sw/2;
		}
		this.setBounds((sw-dialogWidth)/2, (sh-dialogHeight)/2, dialogWidth, dialogHeight);
		JPanel panel1 = new JPanel(new FlowLayout(FlowLayout.LEADING));
		
		JPanel panel2 = new JPanel(new FlowLayout(FlowLayout.LEADING));
		
		JPanel panel3 = new JPanel(new FlowLayout(FlowLayout.TRAILING));
		
		//JPanel panel4 = new JPanel(new FlowLayout(FlowLayout.LEADING));
		
		//JPanel panel5= new JPanel(new FlowLayout(FlowLayout.LEADING));
		
		JPanel loginpanel = new JPanel(new GridLayout(0,1));

		//versionLabel = new JLabel("Softwareversion");
		//versionLabel.setPreferredSize(new Dimension(100,25));
		//panel5.add(versionLabel);
		//versionLabel = new JLabel("v.1.1."+version.substring(5, version.length()-1))
		
		String title="Anmelden";
		this.setTitle(title);

		//usernameText=new JLabel("Datenbank");
		//usernameText.setPreferredSize(new Dimension(100,25));
		//cbInstance=new JComboBox();
		//cbInstance.setPreferredSize(new Dimension(250,25));
		//cbInstance.addActionListener(this);
		//panel4.add(usernameText);
		//panel4.add(cbInstance);
		
		//JLabel logobig=new JLabel("");
		//logobig.setBounds((dialogWidth-logobig.getIcon().getIconWidth())/2,30,logobig.getIcon().getIconWidth(),logobig.getIcon().getIconHeight());
		
		//add(logobig);

		usernameText=new JLabel("Benutzername");
		usernameText.setPreferredSize(new Dimension(150,25));
		username = new JTextField("");
		username.setPreferredSize(new Dimension(250,25));
		panel1.add(usernameText);
		panel1.add(username);
		
		passwordText=new JLabel("Passwort");
		passwordText.setPreferredSize(new Dimension(150,25));
		password = new JPasswordField();
		password.setPreferredSize(new Dimension(250,25));
		panel2.add(passwordText);
		panel2.add(password);
		//loginpanel.add(panel5);
		//loginpanel.add(panel4);
		loginpanel.add(panel1);
		loginpanel.add(panel2);
		
		this.lb=new JButton("Anmelden");
		
		this.getRootPane().setDefaultButton(lb);
		this.lb.addActionListener(this);
		this.lb.setActionCommand("login");
		panel3.add(lb);
		//this.bp.add(lb);
		
		this.cb=new JButton("Abbrechen");

		this.cb.addActionListener(this);
		this.cb.setActionCommand("cancel");
		panel3.add(cb);

		
		loginpanel.add(panel3);
		
	//	if (lastUsername != null) {
		//	password.requestFocus();
	//	}
		loginpanel.setBounds(125,70,360,180);
		add(loginpanel);

	}
	

	
	@Override
	public void actionPerformed( ActionEvent e ) {
		
		
		if ( e.getActionCommand().equalsIgnoreCase("cancel") ) {
			this.password.setText("");
			this.username.setText("");
			this.setVisible(false);
		}
		
		if ( e.getActionCommand().equalsIgnoreCase("login") ) {
			this.setVisible(false);
		}
		//countTrials++;
		
		//JOptionPane.showMessageDialog(this,"Benutzername oder Passwort nicht korrekt!", "Fehler", JOptionPane.ERROR_MESSAGE);
		//if (countTrials>=3) {
		//	this.setVisible(false);
		//}
	
		
	}
	
	
	public boolean isOk()
	{
		return isOk;
	}
	
	public String getUsername()
	{
		return this.username.getText();
	}
	
	public String getPassword()
	{
		return new String(this.password.getPassword());
	}
	
	
	public void reset()
	{
		username.setText("");
		password.setText("");
		isOk=false;
	}

	
	
	

}