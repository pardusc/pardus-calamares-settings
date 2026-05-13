/* === This file is part of Calamares - <http://github.com/calamares> ===
 *
 *   Copyright 2015, Teo Mrnjavac <teo@kde.org>
 *   Copyright 2018-2019, Jonathan Carter <jcc@debian.org>
 *
 *   Calamares is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, or (at your option) any later version.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    property int currentSlide: 1
    property int maxSlide: 0

    function nextSlide() {
        /* Try to load the next slide, if it fails, loop back to 1
         * an attempt to make sure the slides aren't hardcoded
         */
        if (scoutImage.status === Image.Error) {
            if (presentation.maxSlide == 0) {
                presentation.maxSlide = presentation.currentSlide;
            }
            presentation.currentSlide = 1;
        } else {
            presentation.currentSlide++;
        }
        slideTimer.restart(); // Reset timer on manual click
    }

    function prevSlide() {
        // Prevent going backwards past 1, since the scout hasn't found the end yet
        if (presentation.currentSlide > 1) {
            presentation.currentSlide--;
        } else if (presentation.maxSlide > 0) {
            presentation.currentSlide = presentation.maxSlide;
        }
        slideTimer.restart(); // Reset timer on manual click
    }

    Timer {
        id: slideTimer
        interval: 20000 // 20 seconds per slide
        repeat: true
        running: true
        onTriggered: presentation.nextSlide()
    }

    Slide {
        anchors.fill: parent

        Image {
            id: background
            source: "slide" + presentation.currentSlide + ".png"

            anchors.fill: parent
            fillMode: Image.Stretch

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        presentation.nextSlide();
                    } else if (mouse.button === Qt.RightButton) {
                        presentation.prevSlide();
                    }
                }
            }
        }

        /*
         * This is a scout image that always tries to load the next slide,
         * so we can detect when we reach the end of the images (qml image error)
         * and loop back to 1
        */
        Image {
            id: scoutImage
            visible: false // Keep it hidden from the user
            source: "slide" + (presentation.currentSlide + 1) + ".png"
        }
    }
}
