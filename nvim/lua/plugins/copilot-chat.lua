return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      require("CopilotChat").setup {
        debug = false,
        proxy = nil,
        allow_insecure = false,
        -- model = "claude-3.7-sonnet",
        model = 'claude-3.5-sonnet',
        temperature = 0.1,
        prompts = {
          Explain = {
            prompt = '/COPILOT_EXPLAIN 選択したコードの説明を段落をつけて書いてください。',
          },
          Fix = {
            prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
          },
          Optimize = {
            prompt = '/COPILOT_OPTIMIZE 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
          },
          Docs = {
            prompt = '/COPILOT_DOCS 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
          },
          Tests = {
            prompt = '/COPILOT_TESTS 選択したコードの詳細な単体テスト関数を書いてください。',
          },
          FixDiagnostic = {
            prompt = '/COPILOT_FIXDIAGNOSTIC ファイル内の次のような診断上の問題を解決してください：',
          },
          Commit = {
            prompt = '/COPILOT_COMMIT この変更をコミットしてください。',
          },
          CommitStaged = {
            prompt = '/COPILOT_COMMITSTAGED ステージングされた変更をコミットしてください。',
          },
        },
        window = {
          layout = 'vertical',
          width = 0.3,
          height = 0.3,
          relative = 'editor',
          border = 'single',
          row = 0,
          col = 0,
          title = 'Copilot Chat',
          footer = nil,
          zindex = 1,
        },
      }
    end,
  },
}
