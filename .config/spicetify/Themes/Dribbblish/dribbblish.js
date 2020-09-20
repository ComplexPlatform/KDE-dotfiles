function waitForElement(els, func, timeout = 100) {
    const queries = els.map(el => document.querySelector(el));
    if (queries.every(a => a)) {
        func(queries);
    } else if (timeout > 0) {
        setTimeout(waitForElement, 300, els, func, --timeout);
    }
}

// Add "Open User Profile" item in profile menu
new Spicetify.Menu.Item(window.__spotify.username, false, () => window.open(window.__spotify.userUri)).register();

waitForElement([".LeftSidebar", ".LeftSidebar__section--rootlist .SidebarList__list"], (queries) => {
    /** Replace Playlist name with their pictures */
    function loadPlaylistImage() {
        const sidebarItem = queries[1].childNodes;

        for (let i = 0; i < sidebarItem.length; i++) {
            const item = sidebarItem[i];
            let link = item.getElementsByTagName("a");
            if (!link || !link[0]) continue;
            link = link[0];

            let href = link.href.replace("app:", "");

            if (href.indexOf("playlist-folder") != -1) {
                const button = item.getElementsByTagName("button")[0]
                button.classList.add("Button", "Button--style-icon-background", "Button--size-28",);
                item.setAttribute("data-tooltip", item.innerText);
                link.firstChild.innerText = item.innerText.slice(0, 3);
                continue;
            }

            if (href.indexOf("chart") != -1) {
                href = href.replace("chart:", "user:spotifycharts:playlist:");
            }

            Spicetify.CosmosAPI.resolver.get({
                url: `sp://core-playlist/v1/playlist/${href}/metadata`,
                body: { policy: { picture: true } },
            }, (err, res) => {
                if (err) return;
                const meta = res.getJSONBody().metadata;
                item.firstChild.className = "playlist-picture"
                item.firstChild.style.backgroundImage = `url(${meta.picture})`;
                item.firstChild.setAttribute("data-tooltip", item.textContent);
            });
        }
    }

    loadPlaylistImage();

    new MutationObserver(loadPlaylistImage)
        .observe(queries[1], {childList: true});

    /** Replace Apps name with icons */

    /** List of avaiable icons to use:
    addfollow           filter          more                skipforward15
    addfollowers        flag            newradio            sort
    addsuggestedsong    follow          notifications       sortdown
    album               fullscreen      offline             sortup
    artist              gears           pause               spotifylogo
    attach              headphones      play                star
    block               heart           playlist            stations
    bluetooth           helpcircle      plus                subtitles
    browse              home            podcasts            tag
    camera              inbox           queue               time
    check               instagram       radio               track
    collection          lightning       refresh             trending
    copy                localfile       released            user
    devices             locked          repeat              video
    discover            lyrics          repeatonce          volume
    download            menu            search              watch
    downloaded          messages        share               x
    edit                mic             shuffle             helpcircle
    email               minimise        skip
    events              mix             skipback15
    */

    function replaceTextWithIcon(el, iconName) {
        el.classList.add(`spoticon-${iconName}-24`);
        el.setAttribute("data-tooltip", el.innerText);
        el.innerText = "";
    }

    queries[0].querySelectorAll(".LeftSidebar__section:not(.LeftSidebar__section--rootlist) [href]")
        .forEach(item => {
            let icon = ((app) => {switch (app) {
                case "genius":                  return "lyrics";
                case "JQBX":                    return "addsuggestedsong";
                case "bookmark":                return "tag";
                case "reddit":                  return "discover";
                case "made-for-you":            return "user";
                case "recently-played":         return "time";
                case "collection-songs":        return "collection";
                case "collection:albums":       return "album";
                case "collection:artists":      return "artist";
                case "collection:podcasts":     return "podcasts";
                case "playlist:local-files":    return "localfile";
                case "stations":                return "stations";
            }})(item.href.replace("spotify:app:", ""));

            replaceTextWithIcon(item.firstChild, icon);
        });

    waitForElement([`[href="spotify:app:recently-played"]`], ([query]) => {
        replaceTextWithIcon(query.firstChild, "time");
    });
});

waitForElement(["#search-input"], (queries) => {
    queries[0].setAttribute("placeholder", "");
});

waitForElement(["#main-container"], (queries) => {
    const shadow = document.createElement("div");
    shadow.id = "dribbblish-back-shadow";
    queries[0].prepend(shadow);
});

waitForElement([".LeftSidebar"], (queries) => {
    const fade = document.createElement("div");
    fade.id = "dribbblish-sidebar-fade-in";
    queries[0].append(fade);
});
