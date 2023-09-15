package com.dcs.autofill_service

import android.annotation.SuppressLint
import android.graphics.drawable.Icon
import android.widget.RemoteViews
import androidx.annotation.DrawableRes

/**
 * This is a class containing helper methods for building Autofill Datasets and Responses.
 */
object RemoteViewsHelper {

     @SuppressLint("RemoteViewLayout")
     fun simpleRemoteViews(
        packageName: String,
    ): RemoteViews {
        val presentation = RemoteViews(
                packageName,
                R.layout.multidataset_service_list_item
        )
        return presentation
    }
}