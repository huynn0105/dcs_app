package com.keevault.flutter_autofill_service

import android.graphics.drawable.Icon
import android.widget.RemoteViews
import androidx.annotation.DrawableRes

/**
 * This is a class containing helper methods for building Autofill Datasets and Responses.
 */
object RemoteViewsHelper {

     fun simpleRemoteViews(
        packageName: String,
    ): RemoteViews {
        val presentation = RemoteViews(
                packageName,
                R.layout.multidataset_service_list_item
        )
//        presentation.setTextViewText(R.id.text, remoteViewsText)
//        val icon = Icon.createWithResource(packageName, drawableId)
//        presentation.setImageViewIcon(R.id.icon, icon)
        return presentation
    }
}