import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.telephony.SmsMessage
import android.util.Log

class ExampleBroadCast : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val bundle: Bundle? = intent.extras
        if (bundle != null) {
            val pdus = bundle["pdus"] as Array<*>
            for (pdu in pdus) {
                val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray)
                val sender = smsMessage.originatingAddress
                val messageBody = smsMessage.messageBody

                Log.d("SMSReceiver", "SMS received from $sender: $messageBody")
                // Pass SMS data to Flutter
            }
        }
    }
}
