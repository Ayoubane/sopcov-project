package sopcov.mail;
import database.DB;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
/**
 *
 * @author seb
 */
public class MailSender extends Thread{
    
    String from ;
    String username ;
    String password ;
    String host ;
    Properties props;
    Message message ;
    List<String> receivers = new ArrayList<>();
    
    public MailSender(){      
        initialize();
    }
    
    public void initialize() {
        // initialization
        
        // Sender's email ID needs to be mentioned
        from = "teamsopcov@gmail.com";
        username = "teamsopcov@gmail.com";//should be static ( the application send a email
        password = "sopcov123";//should be static it's the application that send a email
        
        // Assuming you are sending email through etud-mel.insa-toulouse.fr
        host = "smtp.gmail.com";
        
        props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        
        // Get the Session object.
        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });
        
        // Create a default MimeMessage object.
        message = new MimeMessage(session);
        
        try{
            // Set Subject: header field + from (are always the same)
            message.setSubject("Notification SopCov");
            message.setFrom(new InternetAddress(from));
        }catch(MessagingException e){
            System.err.println("message could not be set");
        }
    }
    
    public void setEmailText(boolean isAdded){
        try{           
            if (isAdded){
                // si un nouveau covoiturage est possible
                message.setText("Bonjour,\n\n"
                        + "Nous sommes heureux de vous annoncer qu'il y a un nouveau conducteur susceptible de vous proposer un covoiturage sur votre trajet.\n"
                        + "Pour plus d'information veuillez vous rendre sur notre site SopCov : http://localhost:8080/SopCov/index.jsp\n"
                        + "Bonne journée.\n"
                        + "L'équipe SopCov");                
            }else{
                // si un possible covoiturage nous est supprimé
                message.setText("Bonjour,\n\n"
                        + "Nous avons le regrès de vous annoncer qu'un conducteur susceptible de vous proposer un covoiturage ne prend plus votre trajet.\n"
                        + "Pour plus d'information veuillez vous rendre sur notre site SopCov : http://localhost:8080/SopCov/index.jsp\n"
                        + "Bonne journée.\n"
                        + "L'équipe SopCov");
            }
        }catch(MessagingException ex){
            System.err.println("IN - Mail sender : Message text could not be setted , error :" + ex);
        }
    }
    
    public void sendNotificationEmail(String to){
        try{
            //on choisit le destinataire
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to));
          
            // on envoit le mail
            Transport.send(message);
            
            System.out.println("In mailSender - Sent message successfully to : "+ to);
            
        } catch (MessagingException e) {
            System.err.println("In mailSender - Could not send the message "+ e);
        }
    }
    
    public void setList(List<String> emails){
        receivers = emails;
    }
    
    @Override
    public void run(){  
        //pour tous les @mail de notre list ( rempli par la DB )
        if (receivers != null){
            for (String email : receivers){
                // envoie a l'utilisateur
                sendNotificationEmail(email);
            }        
        }
    }
}
