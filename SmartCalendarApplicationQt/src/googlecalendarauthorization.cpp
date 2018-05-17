#include "googlecalendarauthorization.h"

#include <QDesktopServices>
#include <QOAuthHttpServerReplyHandler>
#include <qoauth2authorizationcodeflow.h>


GoogleCalendarAuthorization::GoogleCalendarAuthorization(QObject *parent) : QObject(parent)
{
    authorizationFlow = new QOAuth2AuthorizationCodeFlow(this);
    authorizationFlow->setScope("https://www.googleapis.com/auth/calendar");
    connect(authorizationFlow, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser,
        &QDesktopServices::openUrl);

    authorizationFlow->setAuthorizationUrl(QUrl("https://accounts.google.com/o/oauth2/auth"));
    authorizationFlow->setClientIdentifier("519174763143-12v9kv06h4rm6aehp67cfv3gg9gerji8.apps.googleusercontent.com");
    authorizationFlow->setAccessTokenUrl(QUrl("https://accounts.googlew.com/o/oauth2/token"));
    authorizationFlow->setClientIdentifierSharedKey("iVLAK5S6c5huXjgRCwdJ8OXl");

    QOAuthHttpServerReplyHandler * replyHandler = new QOAuthHttpServerReplyHandler(49517, this);
    replyHandler->setCallbackPath("Callback/");
    authorizationFlow->setReplyHandler(replyHandler);

    connect(authorizationFlow,&QOAuth2AuthorizationCodeFlow::statusChanged,this,[](QOAuth2AuthorizationCodeFlow::Status status)
    {
        qDebug() << "authorizationFlow Calendar Authorization Status " + QString::number((int)status) + " received";
    });

    connect(authorizationFlow,SIGNAL(granted()),this,SIGNAL(granted()));
    connect(authorizationFlow,&QOAuth2AuthorizationCodeFlow::requestFailed,this,&GoogleCalendarAuthorization::failed);

}

QObject *GoogleCalendarAuthorization::singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    QObject * object = new GoogleCalendarAuthorization();
    return object;

}

void GoogleCalendarAuthorization::startAuthorization()
{
    authorizationFlow->grant();

}
