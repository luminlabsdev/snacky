import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  base: "/Snacky/",
  title: "Snacky",
  titleTemplate: ":title - Lumin",
  description: "An efficient way to show snackbar hints",
  lastUpdated: true,
  lang: 'en-us',
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      {
        text: 'Articles',
        items: [
          { text: 'Guides', link: '/guides/' },
          { text: 'Installation', link: '/installation' },
        ]
      },

      { text: 'API', link: '/api/' },
      { text: 'Changelog', link: '/changelog' },
    ],

    sidebar: {
      '/guides': [
        {
          text: 'Guides',
          items: [
            { text: 'Basic Usage', link: '/guides/' },
            { text: 'Respond to Input', link: '/guides/input' },
          ]
        }
      ],

      '/api': [
        {
          text: 'API Reference',
          items: [
            { text: 'Snacky', link: '/api/' },
            { text: 'Snackbar', link: '/api/snackbar' },
            { text: 'Broadcast', link: '/api/broadcast' },
          ]
        },
      ],
    },

    outline: [2, 3],

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/lumin-dev/Snacky/edit/main/docs/:path'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/lumin-dev/Snacky' },
      { icon: 'discord', link: 'https://lumin-dev.github.io/link/discord' },
    ]
  }
})