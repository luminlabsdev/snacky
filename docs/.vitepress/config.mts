import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  head: [['link', { rel: 'icon', href: '/favicon.ico' }]],
  base: "/Snacky/",
  title: "Snacky",
  titleTemplate: "Canary Docs",
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
            { text: 'Snackbar', link: '/api/snackbar' }
          ]
        },
      ],
    },

    outline: [2, 3],

    search: {
      provider: 'local'
    },

    editLink: {
      pattern: 'https://github.com/canary-softworks/Snacky/edit/main/docs/:path'
    },

    footer: {
      message: 'Built with VitePress',
      copyright: 'Copyright © 2021 - 2024 Canary Softworks'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/canary-softworks/Snacky' },
      { icon: 'discord', link: 'https://discord.gg/cwwcZtqJAt' },
    ]
  }
})