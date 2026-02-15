declare module "midtrans-client" {
    interface SnapOptions {
        isProduction: boolean;
        serverKey: string;
        clientKey: string;
    }

    interface TransactionResponse {
        token: string;
        redirect_url: string;
    }

    interface NotificationResponse {
        transaction_status: string;
        order_id: string;
        gross_amount: string;
        payment_type: string;
        fraud_status: string;
        status_code: string;
        signature_key: string;
        transaction_id: string;
        transaction_time: string;
        settlement_time?: string;
    }

    class Snap {
        constructor(options: SnapOptions);
        createTransaction(
            params: Record<string, unknown>
        ): Promise<TransactionResponse>;
    }

    interface CoreApiOptions {
        isProduction: boolean;
        serverKey: string;
        clientKey: string;
    }

    class CoreApi {
        constructor(options: CoreApiOptions);
        transaction: {
            notification(
                notificationJson: Record<string, unknown>
            ): Promise<NotificationResponse>;
        };
    }
}
