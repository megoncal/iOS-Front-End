/*
 
 
 Lembretes
 

 
 client/server - mandatory - precisamos adicionar o código para autenticar o usuário automaticamente quando receber o erro 403 (Eduardo)
 
 server - nice to have - refactory - Generic Audit Fields (version, lastUpdated, etc) (Eduardo)
 
 client - nice to have - refactory - Rationalize keyboard on UI (Eduardo)
 
 server - mandatory - Fazer as chamadas de email a partir do servidor de forma assincrona (Eduardo)
 
 client - secondary - add status to ride detail view controller and then add comments and rating (Eduardo)
 
 client - mandatory - Cancel functionality for unassigned Rides (Marcos)

 server - mandatory - Get most frequent addresses is returning multiple (Eduardo)
 
 server - secondary - Mensagem enviada pelo servidor quando take ride... message 1 updted.. (Eduardo)
 
 client - secondary - Rate ride view controller long text.... check for a place holder... (Marcos) 
 

 
 concluido
 
 
 
 
 1 - falar com eduardo sobre o if que adicionei na classe marshaller... pode gerar efeito colateral.. (Marcos) - DONE
 
 2 - continuam os erros apos o update do driver info e do passenger info... o update funciona, mas posteriormente o usuário e senha ficam invalidos - DONE
 
 4 - CarType Fix (Eduardo) - When editing driver info - DONE
 
 5 - Mask for Passenger Phone (Marcos) - DONE
 
 6 - MyRides (Marcos) - DONE
 
 7 - Wait time indicator (Marcos) - DONE
 
 8 - Create Ride, Take Ride, Complete Ride Test (Eduardo) - DONE
 
 9 - As Passenger, Retrieve Driver assigned to the Ride (Marcos) - DONE
 
 10 - PickupAddress and Complement (Eduardo) - DONE
 
 11 - Can't Complete twice (Marcos) - DONE
 
 12 - Keyboard over in Passenger (Marcos) - DONE
 
 16 - Quando a aplicação abrir verificar se os dados de login estão no keychain e pular a login screen (Marcos) - DONE
 
 17 - Signing up wheel - sign up driver screen - sign up with empty field (Marcos) - DONE
 
 18 - taking ride instead of creating ride (Marcos) - DONE
 
 19 - remove keyboard as soons as the wheel is presented (Marcos) - DONE
 
 20 - remove success messagem when ride is completed (Marcos) - DONE
 
 21 - segmented rides (status) for my rides (Marcos) - DONE
 
 23 - Sign out command has broken after implementation of item 17.... (Marcos)  - DONE
 
 
 
 */

#import <UIKit/UIKit.h>

@interface UserViewController : UITableViewController

@end
